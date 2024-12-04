`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 14:07:33
// Design Name: 
// Module Name: quadSevenSeg
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


module quadSevenSeg(
    output [6:0] seg, // seven-segment data
    output dp, // dot point
    output an0,
    output an1,
    output an2,
    output an3,
    input [7:0] char0, // rightmost seven-segment
    input [7:0] char1,
    input [7:0] char2,
    input [7:0] char3, // leftmost seven-segment
    input clk
    );
    
    reg [1:0] ns; // next stage
    reg [1:0] ps; // present stage
    reg [3:0] dispEn; // select seven-segment
    
    reg [7:0] char_in;
    wire [6:0] segments;
    assign seg = segments;
    
    charTo7Segment segDecode(segments,char_in);
    assign dp = 1; // dot point corresponse with activated an
    assign {an3,an2,an1,an0} = ~dispEn;

    // state transition every clock
    always @(posedge clk)
        ps = ns;
    
    // 3 below sequences work parallelly
    always @(ps) 
        ns = ps+1;
    
    always @(ps)
        case(ps)
        // Enable selcted seven-segment (TDM)
        // (One-hot)
            2'b00: dispEn = 4'b0001;
            2'b01: dispEn = 4'b0010;
            2'b10: dispEn = 4'b0100;
            2'b11: dispEn = 4'b1000;
        endcase
    
    always @(ps)
        case(ps)
        // Data for each seven-segment
            2'b00: char_in = char0;
            2'b01: char_in = char1;
            2'b10: char_in = char2;
            2'b11: char_in = char3;
        endcase
    
endmodule
