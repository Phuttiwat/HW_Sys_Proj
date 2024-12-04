`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 13:44:45
// Design Name: 
// Module Name: clkToBaudrate
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


module clkToBaudrate(
    output reg baudrateClk,
    input clk
    );
    
    integer counter;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 325) begin 
        // Divide clock by 325
            counter = 0;
            baudrateClk = ~baudrateClk; 
        end 
        // Basys3 Clock = 10ns
        // Clock Frequency = 100 MHz
        // Target baudrate = 9600 Hz
        // counter = ClockFreq/Baudrate/16/2 = 325.5
        // 16: sampling every 16 ticks
        // 2: ?
    end
    
endmodule
