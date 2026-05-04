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
        
        input logic [2:0][31:0] DF, //Datapath FETCH stage
        
        output logic [2:0][31:0] DD  //Datapath DECODE stage
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            DD <= '0;
        end
        else if(en) begin
            DD <= DF;
        end
    end
    
endmodule
