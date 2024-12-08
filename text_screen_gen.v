`timescale 1ns / 1ps

module text_screen_gen(
    input clk, reset,
    input video_on,
    input new_data,           // New data signal
    input [6:0] data_in,      // Data to display
    input [9:0] x, y,
    output reg [11:0] rgb
    );

    // signal declaration
    // ascii ROM
    wire [10:0] rom_addr;
    wire [6:0] char_addr;
    wire [3:0] row_addr;
    wire [2:0] bit_addr;
    wire [7:0] font_word;
    wire ascii_bit;
    // tile RAM
    wire we;                    // write enable
    wire [11:0] addr_r, addr_w;
    wire [6:0] din, dout;
    // 80-by-30 tile map
    parameter MAX_X = 80;   // 640 pixels / 8 data bits = 80
    parameter MAX_Y = 30;   // 480 pixels / 16 data rows = 30
    parameter MAX_CHARS_PER_LINE = 8;
    // cursor
    reg [6:0] cur_x_reg;
    reg [4:0] cur_y_reg;
    // delayed pixel count
    reg [9:0] pix_x1_reg, pix_y1_reg;
    reg [9:0] pix_x2_reg, pix_y2_reg;
    // object output signals
    wire [11:0] text_rgb, text_rev_rgb;
    // New cursor position logic
    wire move_cursor_right;

    reg new_data_d1;
    always @(posedge clk) begin
        new_data_d1 <= new_data;
    end
    wire new_data_pulse = new_data & ~new_data_d1; // True only on rising edge of new_data


    // body
    // instantiate the ascii / font rom
    ascii_rom a_rom(.clk(clk), .addr(rom_addr), .data(font_word));
    // instantiate dual-port video RAM (2^12-by-7)
    dual_port_ram dp_ram(
        .clk(clk),
        .we(we),
        .addr_a(addr_w),
        .addr_b(addr_r),
        .din_a(din),
        .dout_a(),
        .dout_b(dout)
    );

    // registers
 always @(posedge clk or posedge reset)
        if(reset) begin
            cur_x_reg <= (MAX_X / 2) - 4; // Start from the middle of the screen
            cur_y_reg <= MAX_Y / 2;
            pix_x1_reg <= 0;
            pix_x2_reg <= 0;
            pix_y1_reg <= 0;
            pix_y2_reg <= 0;
        end
        else begin
            // Move cursor right when new data pulse is detected
            if(new_data_pulse) begin
                // Write the new data to the current cursor position
                if (data_in == 7'h0a || cur_x_reg == MAX_X / 2 + MAX_CHARS_PER_LINE - 5) begin
                    cur_x_reg <= MAX_X / 2 - 4; // Reset to start of line
                    if (cur_y_reg < MAX_Y - 1)
                        cur_y_reg <= cur_y_reg + 1; // Move to next line
                end else begin
                    cur_x_reg <= cur_x_reg + 1;
                end
            end
            pix_x1_reg <= x;
            pix_x2_reg <= pix_x1_reg;
            pix_y1_reg <= y;
            pix_y2_reg <= pix_y1_reg;
        end

    // tile RAM write
    assign addr_w = {cur_y_reg, cur_x_reg};
    assign we = new_data_pulse;
    assign din = data_in;    // Data to write

    // tile RAM read
    // use nondelayed coordinates to form tile RAM address
    assign addr_r = {y[8:4], x[9:3]};
    assign char_addr = dout;

    // font ROM
    assign row_addr = y[3:0];
    assign rom_addr = {char_addr, row_addr};

    // use delayed coordinate to select a bit
    assign bit_addr = pix_x2_reg[2:0];
    assign ascii_bit = font_word[~bit_addr];

    // object signals
    // green over black and reversed video for cursor
    assign text_rgb = (ascii_bit) ? 12'h0F0 : 12'h000;

    // rgb multiplexing circuit
    always @*
        if(~video_on)
            rgb = 12'h000;     // blank
        else
            rgb = text_rgb;

endmodule

