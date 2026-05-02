`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 17:52:37
// Design Name: 
// Module Name: ExecuteRegister
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


module ExecuteRegister(
        input logic clk,
        input logic en,
        input logic clr,
        
        input logic [31:0] DD_32bit [4:0],  //Datapath DECODE stage 32 bit
        input logic [4:0] DD_5bit [2:0],    //Datapath DECODE stage 5 bit
        output logic [31:0] DE_32bit [4:0], //Datapath EXECUTE stage 32 bit
        output logic [4:0] DE_5bit [2:0]    //Datapath EXECUTE stage 5 bit
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            //Datapath  
            for(int i = 0; i < 5; i += 1) begin
                DE_32bit[i] <= 32'b0;
            end
            for(int i = 0; i < 3; i += 1) begin
                DE_5bit[i] <= 5'b0;
            end
        end 
        else if(en) begin
            //Datapath
            for(int i = 0; i < 5; i += 1) begin
                DE_32bit[i] <= DD_32bit[i];
            end
            for(int i = 0; i < 3; i += 1) begin
                DE_5bit[i] <= DD_5bit[i];
            end
        end
    end
    
endmodule
