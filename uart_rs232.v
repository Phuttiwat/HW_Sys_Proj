`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 12:50:22
// Design Name: 
// Module Name: uart_rs232
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


module uart_rs232(
    // save data for seven segment
    output reg [7:0] last_valid_data,
    output RsTx,
    input RsRx,
    input clk,
    input [7:0] data_to_send,
    input send_signal
    );

    reg signal_to_tx, last_receive;
    reg [7:0] data_to_tx;
    reg [7:0] last_data_sent;
    reg [7:0] data_to_send_sync;
    wire [7:0] data_from_rx;
    wire finish_send, finish_receive, baudrateClk;

    clkToBaudrate baudrateClockDivider(baudrateClk, clk);
    rs232_rx receiver(finish_receive, data_from_rx, RsRx, baudrateClk);
    rs232_tx transmitter(finish_send, RsTx, data_to_tx, signal_to_tx, baudrateClk);

    always @(posedge baudrateClk) begin
    
//        if (signal_to_tx) begin
//        // need only 1 bit signal to start sending
//            signal_to_tx = 0;
//        end
//        if (~last_receive & finish_receive) begin
//        // if finished recieve signal change from 0 -> 1 = start sending
//        // (our system protocol)
//            // save data for seven segment
//            last_valid_data = data_from_rx;
//        end
//        // keep track of receive signal
//        last_receive = finish_receive;
        
        
        if (signal_to_tx) begin
            // Need only 1 cycle to start sending
            signal_to_tx <= 0;
        end

        if (send_signal) begin
            // Send data when send_signal is high
            data_to_tx <= data_to_send;
            signal_to_tx <= 1;
            // Save data for seven-segment display
        end
        if (~last_receive & finish_receive) begin
            last_valid_data <= data_from_rx;
        end
        last_receive <= finish_receive;
    end


endmodule
