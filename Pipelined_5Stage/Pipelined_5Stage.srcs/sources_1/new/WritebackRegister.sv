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
        
        input logic [31:0] DM [3:0], //Datapath MEMORY stage
        
        output logic [31:0] DW [3:0] //Datapath WRITEBACK stage
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            //Datapath  
            for(int i = 0; i < 4; i += 1) begin
                DW[i] <= 32'b0;
            end
        end 
        else if(en) begin
            //Datapath
            for(int i = 0; i < 4; i += 1) begin
                DW[i] <= DM[i];
            end
        end
    end
    
endmodule
