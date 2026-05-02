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
        
        input logic [31:0] DD [7:0], //Datapath DECODE stage
        
        output logic [31:0] DE [7:0] //Datapath EXECUTE stage
    );
    
    always_ff @(posedge clk) begin
        if(clr) begin
            //Datapath  
            for(int i = 0; i < 8; i += 1) begin
                DE[i] <= 32'b0;
            end
        end 
        else if(en) begin
            //Datapath
            for(int i = 0; i < 8; i += 1) begin
                DE[i] <= DD[i];
            end
        end
    end
    
endmodule
