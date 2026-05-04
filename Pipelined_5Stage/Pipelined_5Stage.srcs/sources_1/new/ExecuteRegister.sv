`timescale 1ns / 1ps

module ExecuteRegister(
        input logic clk,
        input logic en,
        input logic clr,
        input logic reset,
        
        input logic [4:0][31:0] DD_32bit, 
        input logic [2:0][4:0]  DD_5bit,   
        
        input logic [2:0] CD_3bit, 
        input logic [1:0] CD_2bit,    
        input logic [4:0] CD_1bit,    
        
        output logic [4:0][31:0] DE_32bit, 
        output logic [2:0][4:0]  DE_5bit,  
        
        output logic [2:0] CE_3bit, 
        output logic [1:0] CE_2bit,    
        output logic [4:0] CE_1bit    
    );
    
    always_ff @(posedge clk) begin
        if(clr || reset) begin
            DE_32bit <= '0; 
            DE_5bit  <= '0; 
            CE_3bit  <= '0;
            CE_2bit  <= '0;
            CE_1bit  <= '0;
        end 
        else if(en) begin
            DE_32bit <= DD_32bit;
            DE_5bit  <= DD_5bit;
            CE_3bit  <= CD_3bit;
            CE_2bit  <= CD_2bit;
            CE_1bit  <= CD_1bit;
        end
    end
endmodule