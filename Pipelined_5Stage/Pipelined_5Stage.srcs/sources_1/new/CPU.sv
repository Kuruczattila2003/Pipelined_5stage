`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 14:57:30
// Design Name: 
// Module Name: CPU
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


module CPU(
        input clk,
        input reset
    );
        //ControlUnit
        logic [6:0] opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;
        logic ALUSrcSelectBD;
        logic [2:0] ALUControlD;
        logic JumpD;
        logic BranchD;
        logic DataMemoryWED;
        logic [1:0] WritebackResultSourceD;
        logic RegfileWriteEnableD;
        //Datapath
        logic StallF;
        logic StallD;
        logic FlushD;
        logic FlushE;
        logic [1:0] ForwardAE;
        logic [1:0] ForwardBE;  
        //HazardUnit
        logic [4:0] RSrc1E, RSrc2E;
        logic [4:0] RdM;
        logic [4:0] RdW;
        logic RegWriteM, RegWriteW;
        logic [4:0] RSrc1D, RSrc2D;
        logic [4:0] RdE;
        logic [1:0] WritebackResultSourceE;
        logic PCSrcE;

    
    //for controlling the enable, select signals of the datapath
    ControlUnit controlUnit(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        
        //for EXECUTE stage
        .ALUSrcSelectBD(ALUSrcSelectBD),  
        .ALUControlD(ALUControlD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        //for MEMORY stage
        .DataMemoryWED(DataMemoryWED),
        //for WRITEBACK stage
        .WritebackResultSourceD(WritebackResultSourceD),
        .RegfileWriteEnableD(RegfileWriteEnableD)
    );
    
    //for the main flow of data in the CPU
    Datapath datapath(
        .clk(clk),
        .reset(reset),
        //Control Unit
        .ALUSrcSelectBD(ALUSrcSelectBD),  
        .ALUControlD(ALUControlD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        //for MEMORY stage
        .DataMemoryWED(DataMemoryWED),
        //for WRITEBACK stage
        .WritebackResultSourceD(WritebackResultSourceD),
        .RegfileWriteEnableD(RegfileWriteEnableD),
        
        
        //Hazard Unit signals
        //FETCH stage
        .StallF(StallF), 
        
        //DECODE stage
        .StallD(StallD),
        .FlushD(FlushD),
      
        //EXECUTE stage
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),  
        
        //output
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        
        //Pipeline signals going to Hazard Unit
        .RSrc1D(RSrc1D),
        .RSrc2D(RSrc2D),
        .RSrc1E(RSrc1E),
        .RSrc2E(RSrc2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegfileWriteEnableM(RegWriteM),
        .RegfileWriteEnableW(RegWriteW),
        .WritebackResultSourceE(WritebackResultSourceE),
        .PCSrcE(PCSrcE)
    );
    
    //for handling data and control hazards
    HazardUnit hazardUnit(
        .RSrc1E(RSrc1E),
        .RSrc2E(RSrc2E),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        
        //for lw check
        .RSrc1D(RSrc1D), 
        .RSrc2D(RSrc2D),
        .RdE(RdE),
        .WritebackResultSourceE(WritebackResultSourceE),
        
        //branch instruction
        .PCSrcE(PCSrcE),
        
        //forwarding
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        
        //load stall
        .StallF(StallF),
        .StallD(StallD),
        
        //branch
        .FlushD(FlushD),
        .FlushE(FlushE)
    );
    
endmodule
