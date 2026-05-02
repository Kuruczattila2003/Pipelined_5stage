`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 20:07:25
// Design Name: 
// Module Name: WritebackRegister
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


module WritebackRegister(
        input logic clk,
        input logic en,
        input logic clr,
        
        input logic [2:0][31:0] DM_32bit, 
        input logic [4:0]       DM_5bit,  
        
        input logic [1:0] CM_2bit,    
        input logic       CM_1bit,    
        
        output logic [2:0][31:0] DW_32bit, 
        output logic [4:0]       DW_5bit,  
        
        output logic [1:0] CW_2bit,    
        output logic       CW_1bit    
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            DW_32bit <= '0;
            DW_5bit  <= '0;
            CW_2bit  <= '0;
            CW_1bit  <= '0;
        end 
        else if(en) begin
            DW_32bit <= DM_32bit;
            DW_5bit  <= DM_5bit;
            CW_2bit  <= CM_2bit;
            CW_1bit  <= CM_1bit;
        end
    end
endmodule
