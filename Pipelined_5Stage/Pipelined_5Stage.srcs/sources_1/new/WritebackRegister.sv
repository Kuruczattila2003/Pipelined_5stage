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
        
        input logic [31:0] DM_32bit [2:0],      //Datapath MEMORY stage 32 bit
        input logic [4:0] DM_5bit,              //Datapath MEMORY stage 5 bit
        output logic [31:0] DW_32bit [2:0],     //Datapath WRITEBACK stage 32 bit
        output logic [4:0] DW_5bit              //Datapath WRITEBACK stage 5 bit
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            //Datapath  
            for(int i = 0; i < 3; i += 1) begin
                DW_32bit[i] <= 32'b0;
            end
            for(int i = 0; i < 1; i += 1) begin
                DW_5bit[i] <= 5'b0;
            end
        end 
        else if(en) begin
            //Datapath
            for(int i = 0; i < 3; i += 1) begin
                DW_32bit[i] <= DM_32bit[i];
            end
            for(int i = 0; i < 1; i += 1) begin
                DW_5bit[i] <= DM_5bit[i];
            end
        end
    end
    
endmodule
