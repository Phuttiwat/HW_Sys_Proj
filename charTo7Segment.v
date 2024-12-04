`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 13:03:02
// Design Name: 
// Module Name: charTo7Segment
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


module charTo7Segment(
    output reg [6:0] segments,
    input [7:0] char
    );

//---------------- Table Siekoo Alphabet: ----------------
//the alphabet for a confusion-free 7-segment display

// (The bits order are currently reversed)

//character A	0000010
//character B	1100000
//character C	1110010
//character D	1000010
//character E	0110000
//character F	0111000
//character G	0100001
//character H	1101000
//character I	0111011
//character J	0100111
//character K	0101000
//character L	1110001
//character M	0101010
//character N	1101010
//character O	1100010
//character P	0011000
//character Q	0001100
//character R	1111010
//character S	0100101
//character T	1110000
//character U	1100011
//character V	1010101
//character W	1010100
//character X	1101011
//character Y	1000100
//character Z	0010011
 
//character 1	1001111
//character 2   0010010
//character 3	0000110
//character 4	1001100
//character 5	0100100
//character 6	0100000
//character 7	0001111
//character 8	0000000
//character 9	0000100
//character 0	0000001
 
//character .	1111011
//character ,	1100111
//character ;	1010111
//character :	0110111
//character !	0010100
//character ?	0010110
//character +	1001110
//character -	1111110
//character =	1110110
//character *	0110110
//character #	1001001
//character /	1011010
//character \	1101100
//character ¯	0111111
//character _	1110111
//character (	0110001
//character )	0000111
//character '	1111101
//character "	1011101
//character °	0011100
//character <	0111101
//character >	0011111
//character %	1101101
//character @	0001011

// (The bits order are currently reversed)

// Our notation
// 7-segment encoding
// (Bit 6 to 0 = left to right)
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

    always @(char) begin
        case (char)
        // HexCode = 41
            "A" : segments = 7'b0100000;
            "B" : segments = 7'b0000011;
            "C" : segments = 7'b0100111;
            "D" : segments = 7'b0100001;
            "E" : segments = 7'b0000110;
            "F" : segments = 7'b0001110;
            "G" : segments = 7'b1000010;
            "H" : segments = 7'b0001011;
            "I" : segments = 7'b1101110;
            "J" : segments = 7'b1110010;
            "K" : segments = 7'b0001010;
            "L" : segments = 7'b1000111;
            "M" : segments = 7'b0101010;
            "N" : segments = 7'b0101011;
            "O" : segments = 7'b0100011;
            "P" : segments = 7'b0001100;
            "Q" : segments = 7'b0011000;
            "R" : segments = 7'b0101111;
            "S" : segments = 7'b1010010;
            "T" : segments = 7'b0000111;
            "U" : segments = 7'b1100011;
            "V" : segments = 7'b1010101;
            "W" : segments = 7'b0010101;
            "X" : segments = 7'b1101011;
            "Y" : segments = 7'b0010001;
            "Z" : segments = 7'b1100100;
            "a" : segments = 7'b0100000;
            "b" : segments = 7'b0000011;
            "c" : segments = 7'b0100111;
            "d" : segments = 7'b0100001;
            "e" : segments = 7'b0000110;
            "f" : segments = 7'b0001110;
            "g" : segments = 7'b1000010;
            "h" : segments = 7'b0001011;
            "i" : segments = 7'b1101110;
            "j" : segments = 7'b1110010;
            "k" : segments = 7'b0001010;
            "l" : segments = 7'b1000111;
            "m" : segments = 7'b0101010;
            "n" : segments = 7'b0101011;
            "o" : segments = 7'b0100011;
            "p" : segments = 7'b0001100;
            "q" : segments = 7'b0011000;
            "r" : segments = 7'b0101111;
            "s" : segments = 7'b1010010;
            "t" : segments = 7'b0000111;
            "u" : segments = 7'b1100011;
            "v" : segments = 7'b1010101;
            "w" : segments = 7'b0010101;
            "x" : segments = 7'b1101011;
            "y" : segments = 7'b0010001;
        // Highest HexCode = 7A         
            "z" : segments = 7'b1100100;
            "1" : segments = 7'b1111001;
            "2" : segments = 7'b0100100;
            "3" : segments = 7'b0110000;
            "4" : segments = 7'b0011001;
            "5" : segments = 7'b0010010;
            "6" : segments = 7'b0000010;
            "7" : segments = 7'b1111000;
            "8" : segments = 7'b0000000;
            "9" : segments = 7'b0010000;
            "0" : segments = 7'b1000000;
            "." : segments = 7'b1101111;
            "," : segments = 7'b1110011;
            ";" : segments = 7'b1110101;
            ":" : segments = 7'b1110110;
        // Lowest HexCode = 21        
            "!" : segments = 7'b0010100;
            "?" : segments = 7'b0110100;
            "+" : segments = 7'b0111001;
            "-" : segments = 7'b0111111;
            "=" : segments = 7'b0110111;
            "*" : segments = 7'b0110110;
            "#" : segments = 7'b1001001;
            "/" : segments = 7'b0101101;
            "\\" : segments = 7'b0011011;
            "¯" : segments = 7'b1111110;
            "_" : segments = 7'b1110111;
            "(" : segments = 7'b1000110;
            ")" : segments = 7'b1110000;
            "'" : segments = 7'b1011111;
            "\"" : segments = 7'b1011101;
            "°" : segments = 7'b0011100;
            "<" : segments = 7'b1011110;
            ">" : segments = 7'b1111100;
            "%" : segments = 7'b1011011;
            "@" : segments = 7'b1101000;
        // default = display nothing
            default : segments = 7'b1111111;
        endcase
    end
				
endmodule
