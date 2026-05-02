`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 17:29:44
// Design Name: 
// Module Name: DecodeRegister
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


module DecodeRegister(
        input logic clk,
        input logic en,
        input logic clr,
        
        input logic [31:0] InstrF,
        input logic [31:0] PCF,
        input logic [31:0] PCPlus4F,
        
        output logic [31:0] InstrD,
        output logic [31:0] PCD,
        output logic [31:0] PCPlus4D
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            InstrD <= 32'b0;     
            PCD <= 32'b0;  
            PCPlus4D <= 32'b0;  
        end
        else if(en) begin
            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
    end
    
endmodule
