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
        
        input logic [31:0] DE [3:0], //Datapath EXECUTE stage
        
        output logic [31:0] DM [3:0] //Datapath MEMORY stage
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            //Datapath  
            for(int i = 0; i < 4; i += 1) begin
                DM[i] <= 32'b0;
            end
        end 
        else if(en) begin
            //Datapath
            for(int i = 0; i < 4; i += 1) begin
                DM[i] <= DE[i];
            end
        end
    end
    
endmodule

