`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 13:41:57
// Design Name: 
// Module Name: rs232_rx
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


module rs232_rx(
    output reg finish_receive,
    output reg [7:0] data_out,
    input signal_in,
    input clk
    );
    
    reg last_signal_in;
    reg is_receiving = 0;
    reg [7:0] count;
    
    always@(posedge clk) begin
    // 1. is not in the progress of receiveing
    // 2. signal_in change from 1 -> 0 (UART protocol)
        if (~is_receiving & last_signal_in & ~signal_in) begin
        // start receiving
            is_receiving <= 1;
        // reset variables
            finish_receive <= 0;
            count <= 0;
        end
    // keep track of last signal bit
        last_signal_in <= signal_in;
        
    // count ticks since start receiving
        count <= (is_receiving) ? count+1 : 0;
        
    // sampling every 16 ticks
    // LSB to MSB
        case (count)
        // tick 0-15 is the start signal bit so we will ignore it
        // for tick 16-31, we will sampling at tick = 24 (the middle)
            8'd24:  data_out[0] <= signal_in;
            8'd40:  data_out[1] <= signal_in;
            8'd56:  data_out[2] <= signal_in;
            8'd72:  data_out[3] <= signal_in;
            8'd88:  data_out[4] <= signal_in;
            8'd104: data_out[5] <= signal_in;
            8'd120: data_out[6] <= signal_in;
            8'd136: data_out[7] <= signal_in;
        // UART protocol: stop at 8 bit
        // send signal that the receiving process is finished
            8'd152: begin finish_receive <= 1; is_receiving <= 0; end
        endcase
    end
endmodule
