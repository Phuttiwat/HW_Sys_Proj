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
    output reg [7:0] last_valid_data, // Received data
    output RsTx,                      // UART Transmit
    input RsRx,                       // UART Receive
    input clk,                        // System clock
    input [7:0] data_to_send,         // Data to transmit
    input send_signal,                // Signal to initiate transmission
    output reg new_data               // New data received flag
);

    // Internal signals and registers
    reg signal_to_tx;
    reg last_receive;
    reg [7:0] data_to_tx;
    wire [7:0] data_from_rx;
    wire finish_send;
    wire finish_receive;
    wire baudrateClk;

    // Generate baud rate clock
    clkToBaudrate baudrateClockDivider(
        .baudrateClk(baudrateClk),
        .clk(clk)
    );

    // Instantiate UART receiver and transmitter
    rs232_rx receiver(finish_receive, data_from_rx, RsRx, baudrateClk);
    rs232_tx transmitter(finish_send, RsTx, data_to_tx, signal_to_tx, baudrateClk);

    // Initialization
    initial begin
        last_receive = 0;
        signal_to_tx = 0;
        new_data = 0;
    end

    // UART communication logic
    always @(posedge baudrateClk) begin
        // Transmission logic
        if (signal_to_tx) begin
            // Need only 1 cycle to start sending
            signal_to_tx <= 0;
        end
        if (send_signal) begin
            // Send data when send_signal is high
            data_to_tx <= data_to_send;
            signal_to_tx <= 1;
        end

        // Reception logic
        if (~last_receive & finish_receive) begin
            // Rising edge of finish_receive indicates new data received
            last_valid_data <= data_from_rx;
            new_data <= 1; // Set new_data flag
        end else begin
            new_data <= 0; // Clear new_data flag
        end
        // Update last_receive for edge detection
        last_receive <= finish_receive;
    end

endmodule

