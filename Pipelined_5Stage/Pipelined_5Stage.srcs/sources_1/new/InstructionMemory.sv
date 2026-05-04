`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2026 17:21:23
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
        input logic [31:0] A,
        output logic [31:0] RD
    );
    
    logic [31:0] RAM [1023:0];
    
    assign RD = RAM[A[11:2]]; 
    
    initial begin
        for (int i = 0; i < 1024; i++) begin
            RAM[i] = 32'b0;
        end
        $readmemh("program.mem", RAM);
    end
    
endmodule


module DataMemory(
    input logic clk,
    input logic WEN,
    input logic [31:0] A,
    input logic [31:0] WD,
    output logic [31:0] RD
);

    logic [31:0] RAM [1023:0];

    always_ff @(posedge clk) begin
        if(WEN) begin
            RAM[A[11:2]] <= WD;
        end
    end    
    
    initial begin
        for (int i = 0; i < 1024; i++) begin
            RAM[i] = 32'b0;
        end
        $readmemh("data.mem", RAM);
    end
    
    assign RD = RAM[A[11:2]];

endmodule

module RegisterFile(
    input  logic        clk,
    input  logic        WEN,
    input  logic [4:0]  A1, A2, A3,
    input  logic [31:0] WD3,
    output logic [31:0] RD1, RD2
);
    logic [31:0] registers [31:0];

    assign registers[0] = 32'b0;
    
    always_ff @(negedge clk) begin
        if (WEN && (A3 != 5'b0)) begin 
            registers[A3] <= WD3;
        end
    end

    assign RD1 = registers[A1];
    assign RD2 = registers[A2];

endmodule