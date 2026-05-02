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
        input logic FlushE,
        input logic PCSrcE,
        input logic ForwardAE,
        input logic ForwardBE,
        input logic ALUSrcSelectBE,
        input logic [2:0] ALUControlE,
        
        //MEMORY stage
        input logic DataMemoryWE,
        
        //WRITEBACK stage
        input logic RegfileWriteEnableW,
        input logic WritebackResultSourceW
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
    logic [31:0] ALUSrcAE, ALUSrcBE;
    logic [31:0] WriteDataE;
    logic [31:0] PCPlusImmE;
    logic [31:0] ALUResultE;
    logic ZeroE;
    logic NegativeE;
    logic OverflowE;
    logic CarryE;
    
     
    //Execute register
    ExecuteRegister executeRegister(
        .clk(clk),
        .en(1'b1),
        .clr(FlushE),
        
        .DD({Rd1D, Rd2D, RSrc1D, RSrc2D, ImmExtD, RdD, PCPlus4, PCD}),
        .DE({Rd1E, Rd2E, RSrc1E, RSrc2E, ImmExtE, RdE, PCPlusE, PCDE})
    );
    
    //4:1 Multiplexer for ALU A (Forward or not)
    mux4_1_32bit ALUAMux(
        .a(Rd1E),               //Register (00)
        .b(WritebackResultW),   //changed Register from WRITEBACK stage (01) -> Forwarding
        .c(ALUResultM),         //changed Register from MEMORY stage (10) -> Forwarding
        .d(),                   // -
        .s(ForwardAE),          //Should be forwarded or not
        .q(ALUSrcAE)             //ALU Source A
    );
    //4:1 Multiplexer for ALU B (Forward or not)
    mux4_1_32bit ALUBMuxForward(
        .a(Rd2E),               //Register (00)
        .b(WritebackResultW),   //changed Register from WRITEBACK stage (01) -> Forwarding
        .c(ALUResultM),         //changed Register from MEMORY stage (10) -> Forwarding
        .d(),                   // -
        .s(ForwardBE),                   //Should be forwarded or not
        .q(WriteDataE)                    //ALU Source B
    );
    //2:1 Multiplexer for ALU B (Register or Immediate)
    mux2_1_32bit ALUBMuxImmediate(
        .a(WriteDataE),
        .b(ImmExtE),
        .s(ALUSrcSelectBE),
        .q(ALUSrcBE)
    );
    
    //ALU
    ALU alu(
        .A(ALUSrcAE),
        .B(ALUSrcBE),
        .ALUControl(ALUControlE),
        .Y(ALUResultE),
        .Zero(ZeroE),
        .Negative(NegativeE),
        .Overflow(OverflowE),
        .Carry(CarryE)
    );    
    
    //Program Counter + Immediate (for Branch and Jump instructions)
    Prefix_adder PCPlusImmAdder(
        .a(PCE),
        .b(ImmExtE),
        .cin(1'b0),
        .sum(PCPlusImmE),
        .cout()
    );
    
    //---Fourth stage - MEMORY stage---
    //saved from EXECUTE stage 
    logic [31:0] ALUResultM;
    logic [31:0] WriteDataE;
    logic [31:0] RdM;
    logic [31:0] PCPlus4M;
    //MEMORY stage
    logic [31:0] MemoryDataM;
    
    
    //Memory Register
    MemoryRegister memoryRegister(
        .clk(clk),
        .en(1'b1),
        .clr(1'b0),
        
        .DE({ALUResultE, WriteDataE, RdE, PCPlus4E}),
        .DM({ALUResultM, WriteDataM, RdM, PCPlus4M})
    );
    
    //Data Memory
    DataMemory dataMemory(
        .clk(clk),
        .WEN(DataMemoryWE),
        .A(ALUResultM),
        .WD(WriteDataE),
        .RD(MemoryDataM)
    );
    
    
    //---Fifth stage - WRITEBACK stage---
    //saved from MEMORY stage
    logic [31:0] ALUResultW;
    logic [31:0] MemoryDataW;
    logic [31:0] RdW;
    logic [31:0] PCPlus4W;
    //WRITEBACK stage
    logic [31:0] WritebackResultW;
    
    //Writeback Register
    WritebackRegister wriebackRegister(
        .clk(),
        .en(),
        .clr(),
        
        .DM({ALUResultM, MemoryDataM, RdM, PCPlus4M}),
        .DW({ALUResultW, MemoryDataW, RdW, PCPlus4W})
    );
    
    //4:1 Multiplexer for WD3 of RegisterFile 
    mux4_1_32bit WritebackMultiplexer(
        .a(PCPlus4W),               // (00)
        .b(MemDataW),               // (01)
        .c(ALUResultW),             // (10)
        .d(),                       // -
        .s(WritebackResultSourceW),
        .q(WritebackResultW)
    );
    
    
endmodule
