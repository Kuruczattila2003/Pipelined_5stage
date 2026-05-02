`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 19:56:08
// Design Name: 
// Module Name: MemoryRegister
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

module MemoryRegister(
        input logic clk,
        input logic en,
        input logic clr,
        
        input logic [2:0][31:0] DE_32bit, 
        input logic [4:0]       DE_5bit,  
        
        input logic [1:0] CE_2bit,    
        input logic [1:0] CE_1bit,    
        
        output logic [2:0][31:0] DM_32bit, 
        output logic [4:0]       DM_5bit,  
        
        output logic [1:0] CM_2bit,    
        output logic [1:0] CM_1bit    
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            DM_32bit <= '0;
            DM_5bit  <= '0;
            CM_2bit  <= '0;
            CM_1bit  <= '0;
        end 
        else if(en) begin
            DM_32bit <= DE_32bit;
            DM_5bit  <= DE_5bit;
            CM_2bit  <= CE_2bit;
            CM_1bit  <= CE_1bit;
        end
    end
endmodule

