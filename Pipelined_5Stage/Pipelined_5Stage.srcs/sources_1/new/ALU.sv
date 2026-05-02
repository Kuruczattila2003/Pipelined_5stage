`timescale 1ns / 1ps


module ALU(
        input logic [31:0] A, B,
        input logic [2:0] ALUControl,
        output logic [31:0] Y,
        output logic Zero, Negative, Overflow, Carry
    );
    
    logic [31:0] B_ALU;
    logic [31:0] ALU_adder_result;
    
    //sum or diff
    mux2_1_32bit B_mux(B, ~B, ALUControl[0], B_ALU); 
    prefix_adder ALU_Adder(
        .a(A), 
        .b(B_ALU),
        .cin(ALUControl[0]), 
        .sum(ALU_adder_result), 
        .cout(Carry)
     );
    
    //and
    logic [31:0] ALU_AND;
    assign ALU_AND = A & B;
    
    //or
    logic [31:0] ALU_OR;
    assign ALU_OR = A | B;
    
    
    //xor
    logic [31:0] ALU_XOR;
    assign ALU_XOR = A ^ B;
    
    //decision based on ALUControl bits
    mux8_1_32bit finalMux(
        .a(ALU_adder_result),   // 000: ADD
        .b(ALU_adder_result),   // 001: SUB
        .c(ALU_AND),            // 010: AND
        .d(ALU_OR),             // 011: OR
        .e(ALU_XOR),            // 100: XOR
        .f(32'b0),              // 101: unused
        .g(32'b0),              // 110: unused
        .h(32'b0),              // 111: unused
        .s(ALUControl), 
        .q(Y)
    );
    
    assign Zero = (Y == 32'b0);
    assign Negative = Y[31];
    assign Overflow = (A[31] == B_ALU[31]) && (A[31] != Y[31]);
    
endmodule
