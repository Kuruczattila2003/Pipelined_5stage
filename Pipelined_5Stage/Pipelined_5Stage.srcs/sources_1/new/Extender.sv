`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 20:59:26
// Design Name: 
// Module Name: Extend
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


module Extender (
        input logic [6:0] opcode,
        input logic [31:5] instr,
        output logic [31:0] Q
    );
    
    always_comb begin
        if(opcode == 7'b0000011) begin
        //LW instruction
            Q = {{20{instr[31]}}, instr[31:20]};
        end
        else if(opcode == 7'b0100011) begin
        //SW instruction
            Q = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end
        else if(opcode == 7'b1100011) begin
        //BEQ instruction
            Q = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};            
        end
        else if(opcode == 7'b1101111) begin
        //JAL instruction
            Q = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        else begin
            Q = {{20{instr[31]}}, instr[31:20]};
        end
    end 
    
endmodule
