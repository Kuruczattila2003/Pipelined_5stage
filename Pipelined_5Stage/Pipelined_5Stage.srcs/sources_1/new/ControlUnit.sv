`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 14:59:29
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
        input logic [6:0] opcode,
        input logic [14:12] funct3,
        input logic [31:25] funct7,
        
        //for EXECUTE stage
        output logic ALUSrcSelectBD,  
        output logic [2:0] ALUControlD,
        output logic JumpD,
        output logic BranchD,
        //for MEMORY stage
        output logic DataMemoryWED,
        //for WRITEBACK stage
        output logic [1:0] WritebackResultSourceD,
        output logic RegfileWriteEnableD
        
    );
    
    //opcode
    //R-Type opcode: 7'b0110011 
    //B-Type opcode: 7'b1100011
    //I-Type ALU opcode: 7'b0010011
    //I-Type load opcode: 7'b0000011 
    //S-Type store opcode: 7'b0100011
    //J-Type jal opcode: 7'b1101111 
    //U-Type lui opcode: 7'b0110111  
    //U-Type auipc opcode: 7'b0010111 
    
    //                  f3,  f7,        ALUControl
    //addi      ->      000, -,         000
    //lw        ->      010, -          000
    //sw        ->      010, -          000
    //and       ->      111, 0000000    010
    //or        ->      110, 0000000    011
    //add       ->      000, 0000000    000
    //sub       ->      000, 0100000    001
    //beq       ->      000, -          001
    //jal       ->      -,   -          XXX
    
    logic RType, BType, ITypeALU, ITypeLoad, SType, JType, UTypeLui, UTypeAuipc;
    logic isAddi, isLw, isSw, isAnd, isOr, isAdd, isSub, isBeq, isJal;
    
    
    always_comb begin

        RType = (opcode == 7'b0110011);
        BType = (opcode == 7'b1100011);
        ITypeALU = (opcode == 7'b0010011);
        ITypeLoad = (opcode == 7'b0000011);
        SType = (opcode == 7'b0100011);
        JType = (opcode == 7'b1101111);
        UTypeLui = (opcode == 7'b0110111);
        UTypeAuipc = (opcode == 7'b0010111);
        
        isAddi = (funct3 == 3'b000) && ITypeALU;
        isLw = (funct3 == 3'b010) && ITypeLoad;
        isSw = (funct3 == 3'b010) && SType;
        isAnd = (funct3 == 3'b111) && (funct7 == 7'b0000000) && RType;
        isOr = (funct3 == 3'b110) && (funct7 == 7'b0000000) && RType;
        isAdd = (funct3 == 3'b000) && (funct7 == 7'b0000000) && RType;
        isSub = (funct3 == 3'b000) && (funct7 == 7'b0100000) && RType;
        isBeq = (funct3 == 3'b000) && BType;
        isJal = JType;
    
        //For EXECUTION stage
        //ALUSrcSelectBD
        //0 -> use register for B of ALU, 1 -> use immediate value for B of ALU
        //R-Type -> 0, I-Type -> 1, S-Type -> 1, B-Type -> 0, J-Type -> 1, U-type -> 1
        if(RType || BType) begin
            //use register for ALU B
            ALUSrcSelectBD = 1'b0;
        end
        else begin
            //use immediate for ALU B
            ALUSrcSelectBD = 1'b1;
        end
        
        //ALUControlD
        if(isAddi || isLw || isSw || isAdd) begin
            //Add
            ALUControlD = 3'b000; 
        end
        else if(isSub || isBeq) begin
            ALUControlD = 3'b001;
        end
        else if(isAnd) begin
            ALUControlD = 3'b010;
        end
        else if(isOr) begin
            ALUControlD = 3'b011;
        end
        else begin
            ALUControlD = 3'b000;        
        end
        
        //JumpD -> if instruction is a jump
        JumpD = JType;
        
        //BranchD -> if instruction is a branch
        BranchD = BType;

        //For MEMORY stage
        //DataMemoryWED -> Enable write to Data memory
        DataMemoryWED = SType;
        
        //for WRITEBACK stage
        //WritebackResultSourceD -> Choose which data to write to register in RegisterFile
        //.a(PCPlus4W),               // (00)
        //.b(MemoryDataW),            // (01)
        //.c(ALUResultW),             // (10)
        if(JType) begin
            //choose PCPlus4W
            WritebackResultSourceD = 2'b00;
        end
        else if(ITypeLoad) begin
            //choose MemoryDataW
            WritebackResultSourceD = 2'b01;
        end
        else begin
            //choose ALUResultW
            WritebackResultSourceD = 2'b10; //(R-Type, I-Type ALU, U-Type)
        end
        
        //RegfileWriteEnableD -> Enable write for RegisterFile
        RegfileWriteEnableD = RType || ITypeLoad || ITypeALU || JType || UTypeLui || UTypeAuipc;
    
    end
    
endmodule
