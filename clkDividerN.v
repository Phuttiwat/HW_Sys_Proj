`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 20:30:43
// Design Name: 
// Module Name: clkDividerN
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


module clkDividerN #(parameter N=19)(
    output targetClk,
    input inputClk
    );
    
    wire [N-1:0] tclk;
    
    assign tclk[0]= inputClk;
    
    genvar c;
    generate for(c=0;c<N-1;c=c+1) begin
        clkDivider fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clkDivider fdivTarget(targetClk,tclk[N-1]);
    
endmodule
