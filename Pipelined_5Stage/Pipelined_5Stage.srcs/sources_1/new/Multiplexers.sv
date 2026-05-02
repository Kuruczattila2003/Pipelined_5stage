`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 18:11:55
// Design Name: 
// Module Name: Multiplexers
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
module mux2_1 (
    input logic [1:0] a,
    input logic s,
    output logic q
);
    assign q = (~s & a[0]) | (s & a[1]);
endmodule

module mux4_1 (
    input logic [3:0] a,
    input logic [1:0] s,
    output logic q
);

    logic q1, q2;
    mux2_1 m1(.a({a[1], a[0]}), .s(s[0]), .q(q1));
    mux2_1 m2(.a({a[3], a[2]}), .s(s[0]), .q(q2));
    mux2_1 m3(.a({q2, q1}), .s(s[1]), .q(q));
    
endmodule

module mux8_1 (
    input logic [7:0] a,
    input logic [2:0] s,
    output logic q
);

    logic q1, q2;
    mux4_1 m1(.a({a[3], a[2], a[1], a[0]}), .s({s[1], s[0]}), .q(q1));
    mux4_1 m2(.a({a[7], a[6], a[5], a[4]}), .s({s[1], s[0]}), .q(q2));
    mux2_1 m3(.a({q2, q1}), .s(s[2]), .q(q));
    
endmodule

module mux2_1_32bit(
    input logic [31:0] a, b,
    input logic s,
    output logic [31:0] q
);

    genvar i;
    generate
        for(i = 0; i < 32; i += 1) begin: mux2_1_32
            mux2_1 m(.a({b[i], a[i]}), .s(s), .q(q[i]));
        end
    endgenerate
    
endmodule

module mux4_1_32bit(
    input logic [31:0] a, b, c, d,
    input logic [1:0] s,
    output logic [31:0] q
);
    genvar i;
    generate
        for(i = 0; i < 32; i += 1) begin: mux4_1_32
            mux4_1 m(.a({d[i], c[i], b[i], a[i]}), .s(s), .q(q[i]));
        end
    endgenerate
endmodule



module mux8_1_32bit(
    input logic [31:0] a, b, c, d, e, f, g, h,
    input logic [2:0] s,
    output logic [31:0] q
);
    genvar i;
    generate
        for(i = 0; i < 32; i += 1) begin: mux8_1_32
            mux8_1 m(.a({h[i], g[i], f[i], e[i], d[i], c[i], b[i], a[i]}), .s(s), .q(q[i]));
        end
    endgenerate
endmodule


module Multiplexers(

    );
endmodule
