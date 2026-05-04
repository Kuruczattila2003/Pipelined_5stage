`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2026 10:39:38
// Design Name: 
// Module Name: CPU_5staged_pipelined_tb
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

module CPU_5staged_pipelined_tb(

);

    logic clk;
    logic reset;
   

    CPU dut (
        .clk(clk),
        .reset(reset)
    );

    always begin
        clk = 1'b0; #10;
        clk = 1'b1; #10;
    end


    initial begin

        $display("Starting CPU Simulation...");

        reset = 1'b1;

        #35; 
        
        reset = 1'b0; 

        #2000
        $display("Test finished");
        $finish;
    end

endmodule

