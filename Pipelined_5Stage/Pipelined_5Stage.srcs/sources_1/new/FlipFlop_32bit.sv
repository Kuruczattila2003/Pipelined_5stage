`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 15:10:28
// Design Name: 
// Module Name: FlipFlop_32bit
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


module FlipFlop_32bit(
    input logic clk,
    input logic clr,
    input logic en,
    input logic [31:0] next,
    output logic [31:0] Q
);
    always_ff @(posedge clk) begin
        if(clr) begin
            Q <= 32'b0;
        end
        else if(en) begin
            Q <= next;
        end
    end

endmodule
