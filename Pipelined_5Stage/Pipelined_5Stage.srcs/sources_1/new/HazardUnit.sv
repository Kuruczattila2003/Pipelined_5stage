`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 15:00:06
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
        
        //for forwarding
        input logic [4:0] RSrc1E, RSrc2E,
        input logic [4:0] RdM,
        input logic [4:0] RdW,
        input logic RegWriteM, RegWriteW,
        
        //for lw check
        input logic [4:0] RSrc1D, RSrc2D,
        input logic [4:0] RdE,
        input logic [1:0] WritebackResultSourceE,
        
        //branch instruction
        input logic PCSrcE,
        
        //forwarding
        output logic [1:0] ForwardAE,
        output logic [1:0] ForwardBE,
        
        //load stall
        output logic StallF,
        output logic StallD,
        
        //branch
        output logic FlushD,
        output logic FlushE
        
    );
     /*
        logic [4:0] RSrc1E, RSrc2E,
        logic [4:0] RdM,
        logic [4:0] RdW, 
    */
    always_comb begin
        //default:
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        StallF = 1'b0;
        StallD = 1'b0;
        FlushD = 1'b0;
        FlushE = 1'b0;
    
        //forwarding
        //changed Register from WRITEBACK stage (01) -> Forwarding
        //changed Register from MEMORY stage (10) -> Forwarding
        if(RegWriteM && (RSrc1E == RdM) && (RSrc1E != 5'b0)) begin
             ForwardAE = 2'b10;
        end
        else if(RegWriteW && (RSrc1E == RdW) && (RSrc1E != 5'b0)) begin
             ForwardAE = 2'b01;
        end
        
        if(RegWriteM && (RSrc2E == RdM) && (RSrc2E != 5'b0)) begin
             ForwardBE = 2'b10;
        end
        else if(RegWriteW && (RSrc2E == RdW) && (RSrc2E != 5'b0)) begin
             ForwardBE = 2'b01;
        end
        
        //lw instruction stall
        if((WritebackResultSourceE == 2'b01) && ((RSrc1D == RdE) || (RSrc2D == RdE))) begin 
        //if it is a load instruction and the decode source == execute destination
            StallF = 1'b1;
            StallD = 1'b1;
            FlushE = 1'b1;
        end
        
        //branch instruction
        if(PCSrcE) begin
        //if it is a branch instruction and Zero == 1'b0 -> FlushD, FlushE
            FlushD = 1'b1;
            FlushE = 1'b1;
        end
    end
    
    
endmodule
