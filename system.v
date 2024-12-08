`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 12:40:40
// Design Name: 
// Module Name: system
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module system(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output JA_0, //uart TX
    input JA_1, //uart RX
    input [7:0] sw, 
    input btnC, //push data
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input reset,
    input set,
    input clk,
    output hsync, vsync,    // VGA connector
//    output [3:0] vgaRed,   // Red channel
//    output [3:0] vgaGreen, // Green channel
//    output [3:0] vgaBlue  // Blue channel
    output [11:0] rgb      // Combined RGB signal
    );
    
//    assign rgb = {vgaRed,vgaGreen,vgaBlue};
    wire [7:0] last_valid_data;
    
//    assign vgaRed   = rgb[11:8]; // Most significant 4 bits for Red
//    assign vgaGreen = rgb[7:4];  // Middle 4 bits for Green
//    assign vgaBlue  = rgb[3:0];  // Least significant 4 bits for Blue

    // Clock (For TDM) 10ns * 2^19 ~ 5ms
    // (All four digits should be driven once every 1-16 ms)
    wire tdmClk;
    clkDividerN #(19) tdmClkDivider(tdmClk, clk);
    
//    wire d,notd,d2,notd2 ;
//    dFlipflop dFF2(d2,notd2,btnU,tdmClk);
//    dFlipflop dFF(d,notd,d2,tdmClk);
//    wire debounce_btnU ;
//    singlePulser debounce(debounce_btnU,d,tdmClk); 
      
    // UART Module (Using USB-RS232)
    wire new_data; // Signal indicating new data received
    uart_rs232 uart(
        .last_valid_data(last_valid_data),
        .RsTx(JA_0),
        .RsRx(JA_1),
        .clk(clk),
        .data_to_send(sw),
        .send_signal(btnC),
        .new_data(new_data) // Connect the new_data signal
    );
    top(
        .clk(clk),
        .reset(reset),
        .last_valid_data(last_valid_data[6:0]),
        .new_data(new_data),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    
    // Seven Segment
    reg [7:0] char3,char2,char1,char0; // left to right
    
    wire an0,an1,an2,an3; // anode for seven-segment
    assign an={an3,an2,an1,an0};
    
//    top(clk,reset,set,btnU,btnD,btnL,btnR,last_valid_data[6:0],hsync,vsync,rgb);
    
    // Seven Segment Module
    quadSevenSeg sevenSegment(seg,dp,an0,an1,an2,an3,char0,char1,char2,char3,tdmClk);
    
    // Segment Data Changes
    always @(posedge tdmClk) begin
        if (btnC) char0 = sw;
        // char 1-3 is not used rignt now
        char2 = last_valid_data;
    end
    
endmodule
