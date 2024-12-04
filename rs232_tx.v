`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 13:41:57
// Design Name: 
// Module Name: rs232_tx
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


module rs232_tx(
    output reg finish_send,
    output reg signal_out,
    input [7:0] data_to_transmit,
    input signal_in,
    input clk
    );
    
    reg last_signal_in;
    reg is_sending = 0;
    reg [7:0] count;
    reg [7:0] data;
    
    always@(posedge clk) begin
    // 1. is not in the progress of sending
    // 2. signal_in change from 0 -> 1 (our system protocol)
        if (~is_sending & ~last_signal_in & signal_in) begin
        // save data signal
            data <= data_to_transmit;
        // start sending
            is_sending <= 1;
        // reset variables
            finish_send <= 0;
            count <= 0;
        end
        
    // keep track of last signal bit
        last_signal_in <= signal_in;
        
        if (is_sending) begin
        // count ticks since start sending
            count <= count + 1;
        end
        else begin
            count <= 0;
        // signal_out stay at 1 (1 -> 0 = start bit)
            signal_out <= 1; 
        end
        
    // sampling every 16 ticks
    // LSB to MSB
        case (count)
        // tick 0-15 is the start signal, we will set at the middle(8)
            8'd8: signal_out <= 0;
        // for tick 16-31, we will sampling at tick = 24 (the middle)
            8'd24: signal_out <= data[0];  
            8'd40: signal_out <= data[1];
            8'd56: signal_out <= data[2];
            8'd72: signal_out <= data[3];
            8'd88: signal_out <= data[4];
            8'd104: signal_out <= data[5];
            8'd120: signal_out <= data[6];
            8'd136: signal_out <= data[7];
        // UART protocol: stop at 8 bit
        // send signal that the sending process is finished
            8'd152: begin finish_send <= 1; is_sending <= 0; end
        endcase
    end
endmodule
