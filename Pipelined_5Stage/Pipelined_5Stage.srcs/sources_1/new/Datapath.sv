`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 14:58:30
// Design Name: 
// Module Name: Datapath
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


module Datapath(
        input clk,
        input reset,
        //select signals
        //FETCH stage
        input logic StallF, //stalling FETCH state
        
        //DECODE stage
        input logic StallD,
        input logic FlushD,
      
        //EXECUTE stage
        input logic PCSrcE,
        
        //MEMORY stage
        
        //WRITEBACK stage
        input logic RegfileWriteEnableW
    );
    
    //FETCH stage wires
    logic [31:0] PCNextF;
    logic [31:0] PCF;
    logic [31:0] PCPlus4F;
    logic [31:0] InstrF;
    
    //Multiplexer for source of Pnext
    mux2_1_32bit PCSrcMux(
        .a(PCPlus4F),
        .b(PCPlusImmE),
        .s(PCSrcE),
        .q(PCNextF)
    );
    
    //---First stage - FETCH stage---
    //Register for PC
    FlipFlop_32bit FetchRegister(
        .clk(clk),
        .clr(reset), //to put CPU in a stabil starting position
        .en(!StallF), //when we want to stall the CPU Fetch Stage
        .next(PCNextF),
        .Q(PCF)
    );
    
    //Adder for PC + 4 calculation
    Prefix_adder PCPlus4Adder(
        .a(PCF),    //Program Counter
        .b(32'h4),  //+4
        .cin(1'b0),
        .sum(PCPlus4F),
        .cout()
    );
   
    //Instruction memory
    InstructionMemory instructionMemory(
        .A(PCF),
        .RD(InstrF)
    );
    
    //---Second stage - DECODE stage---
    //saved from FETCH stage
    logic [31:0] InstrD;
    logic [31:0] PCD;
    logic [31:0] PCPlus4D;
    //from DECODE stage
    logic [31:0] Rd1D, Rd2D;
    logic [31:0] RSrc1D, RSrc2D, RdD;
    logic [31:0] ImmExtD;
    
    //pipeline register for Decode stage
    DecodeRegister decodeRegister(
        .clk(clk),
        .en(!StallD),
        .clr(FlushD),
        
        .DF({InstrF, PCF, PCPlus4F}),   //Datapath FETCH stage
        .DD({InstrD, PCD, PCPlus4D})    //Datapath DECODE stage
    );
    
    
    //RegisterFile -> Read register data based on instruction
    assign RSrc1D = InstrD[19:15];
    assign RSrc2D = InstrD[24:20];
    RegisterFile registerFile(
        .clk(clk),
        .WEN(RegfileWriteEnableW), //Write enable from WRITEBACK stage (for write)
        .A1(RSrc1D), // (for read in DECODE stage)
        .A2(RSrc2D), // (for read in DECODE stage)
        .A3(RdW),      //Destination register from WRITEBACK stage (for write)
        .WD3(WritebackResultW), //Data to write from WRITEBACK stage (for write)
        
        .RD1(Rd1D), //output 1
        .RD2(Rd2D) //output 2
    );
   
    //Extender Unit for extending immediate value of machine code instruction 
    Extender extenderUnit(
        .opcode(InstrD[6:0]),
        .instr(InstrD[31:5]),
        .Q(ImmExtD)  
    ); 
    
    //---Third stage - EXECUTE stage---  
    //saved from DECODE stage
    logic [31:0] Rd1E;
    logic [31:0] Rd2E;
    logic [31:0] RSrc1E;
    logic [31:0] RSrc2E;
    logic [31:0] ImmExtE;
    logic [31:0] RdE;
    logic [31:0] PCPlusE;
    logic [31:0] PCDE;
    //from EXECUTE stage
     
    ExecuteRegister executeRegister(
        .clk(clk),
        .en(1'b1),
        .clr(1'b0),
        
        .DD({Rd1D, Rd2D, RSrc1D, RSrc2D, ImmExtD, RdD, PCPlus4, PCD}),
        .DE({Rd1E, Rd2E, RSrc1E, RSrc2E, ImmExtE, RdE, PCPlusE, PCDE})
    );
    
endmodule
