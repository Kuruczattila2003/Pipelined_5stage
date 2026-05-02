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
        input logic PCSrcE
        
        //DECODE stage
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
    //pipeline register for Decode stage
    DecodeRegister decodeRegister(
        .clk(clk),
        .en(!StallD),
        .clr(FlushD),
        
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F)
    );

        
    //
    
endmodule
