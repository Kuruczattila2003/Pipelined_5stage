`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module full_adder(
    input logic a, b, cin,
    output logic sum, cout
);

    assign sum = a^b^cin;
    assign cout = cin&(a^b) | a&b;

endmodule

module black_box(
    input logic Pleft, Pright, Gleft, Gright,
    output logic P, G 
);

    assign P = Pleft & Pright;
    assign G = (Gright & Pleft) | Gleft;

endmodule

module Prefix_adder (
    input logic [31:0] a, b,
    input logic cin,
    output logic [31:0] sum,
    output logic cout
);

    logic [32:0] P_tree [5:0];
    logic [32:0] G_tree [5:0];
    
    assign G_tree[0][0] = cin;
    assign P_tree[0][0] = 0;
    for(genvar i = 0; i < 32; i++) begin: initial_gp
        assign G_tree[0][i+1] = a[i] & b[i];
        assign P_tree[0][i+1] = a[i] ^ b[i];
     end  
    
    //second section (prefix tree)
    
    genvar lvl, i, j;
generate
    // Example for Level 1 (Stride 2)
    for (i = 1; i <= 32; i += 2) begin : lvl1
        black_box bb1 (
            .Pleft(P_tree[0][i]),   .Pright(P_tree[0][i-1]),
            .Gleft(G_tree[0][i]),   .Gright(G_tree[0][i-1]),
            .P(P_tree[1][i]),       .G(G_tree[1][i])
        );
    end

    // Level 2 (Stride 4)
    for (i = 3; i <= 32; i += 4) begin : lvl2
        black_box bb2a (
            .Pleft(P_tree[1][i]),   .Pright(P_tree[1][i-2]), // Combines results from lvl1
            .Gleft(G_tree[1][i]),   .Gright(G_tree[1][i-2]),
            .P(P_tree[2][i]),       .G(G_tree[2][i])
        );
        black_box bb2b (
            .Pleft(P_tree[0][i-1]),   .Pright(P_tree[1][i-2]), // Combines results from lvl1
            .Gleft(G_tree[0][i-1]),   .Gright(G_tree[1][i-2]),
            .P(P_tree[2][i-1]),       .G(G_tree[2][i-1])
        );
    end
    
    // Level 3 (Stride 8)
    for (i = 7; i <= 32; i += 8) begin : lvl3
        black_box bb3a (
            .Pleft(P_tree[2][i]),   .Pright(P_tree[2][i-4]), // Combines results from lvl1
            .Gleft(G_tree[2][i]),   .Gright(G_tree[2][i-4]),
            .P(P_tree[3][i]),       .G(G_tree[3][i])
        );
        black_box bb3b (
            .Pleft(P_tree[2][i-1]),   .Pright(P_tree[2][i-4]), // Combines results from lvl1
            .Gleft(G_tree[2][i-1]),   .Gright(G_tree[2][i-4]),
            .P(P_tree[3][i-1]),       .G(G_tree[3][i-1])
        );
        black_box bb3c (
            .Pleft(P_tree[1][i-2]),   .Pright(P_tree[2][i-4]), // Combines results from lvl1
            .Gleft(G_tree[1][i-2]),   .Gright(G_tree[2][i-4]),
            .P(P_tree[3][i-2]),       .G(G_tree[3][i-2])
        );
        black_box bb3d (
            .Pleft(P_tree[0][i-3]),   .Pright(P_tree[2][i-4]), // Combines results from lvl1
            .Gleft(G_tree[0][i-3]),   .Gright(G_tree[2][i-4]),
            .P(P_tree[3][i-3]),       .G(G_tree[3][i-3])
        );
    end
    
    // Level 4 (Stride 16)
    for (i = 15; i <= 32; i += 16) begin : lvl4
        black_box bb4a (
            .Pleft(P_tree[3][i]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[3][i]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i]),       .G(G_tree[4][i])
        );
        black_box bb4b (
            .Pleft(P_tree[3][i-1]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[3][i-1]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-1]),       .G(G_tree[4][i-1])
        );
        black_box bb4c (
            .Pleft(P_tree[3][i-2]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[3][i-2]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-2]),       .G(G_tree[4][i-2])
        );
        black_box bb4d (
            .Pleft(P_tree[3][i-3]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[3][i-3]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-3]),       .G(G_tree[4][i-3])
        );
        black_box bb4e (
            .Pleft(P_tree[2][i-4]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[2][i-4]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-4]),       .G(G_tree[4][i-4])
        );
        black_box bb4f (
            .Pleft(P_tree[2][i-5]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[2][i-5]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-5]),       .G(G_tree[4][i-5])
        );
        black_box bb4g (
            .Pleft(P_tree[1][i-6]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[1][i-6]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-6]),       .G(G_tree[4][i-6])
        );
        black_box bb4h (
            .Pleft(P_tree[0][i-7]),   .Pright(P_tree[3][i-8]), // Combines results from lvl1
            .Gleft(G_tree[0][i-7]),   .Gright(G_tree[3][i-8]),
            .P(P_tree[4][i-7]),       .G(G_tree[4][i-7])
        );
    end
    
    // Level 5 (Stride 32)
    for (i = 31; i <= 32; i += 32) begin : lvl5
        for(j = 0; j < 8; j += 1) begin: lvl5_1
            black_box bb5_1 (
                .Pleft(P_tree[4][i-j]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
                .Gleft(G_tree[4][i-j]),   .Gright(G_tree[4][i-16]),
                .P(P_tree[5][i-j]),       .G(G_tree[5][i-j])
            );
        end
        
        for(j = 0; j < 4; j += 1) begin: lvl5_2
            black_box bb5_2 (
                .Pleft(P_tree[3][i-j-8]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
                .Gleft(G_tree[3][i-j-8]),   .Gright(G_tree[4][i-16]),
                .P(P_tree[5][i-j-8]),       .G(G_tree[5][i-j-8])
            );
        end
        
        black_box bb5a (
            .Pleft(P_tree[2][i-12]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
            .Gleft(G_tree[2][i-12]),   .Gright(G_tree[4][i-16]),
            .P(P_tree[5][i-12]),       .G(G_tree[5][i-12])
        );
         black_box bb5b (
            .Pleft(P_tree[2][i-13]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
            .Gleft(G_tree[2][i-13]),   .Gright(G_tree[4][i-16]),
            .P(P_tree[5][i-13]),       .G(G_tree[5][i-13])
        );
        black_box bb5c (
            .Pleft(P_tree[1][i-14]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
            .Gleft(G_tree[1][i-14]),   .Gright(G_tree[4][i-16]),
            .P(P_tree[5][i-14]),       .G(G_tree[5][i-14])
        );
        black_box bb5d (
            .Pleft(P_tree[0][i-15]),   .Pright(P_tree[4][i-16]), // Combines results from lvl1
            .Gleft(G_tree[0][i-15]),   .Gright(G_tree[4][i-16]),
            .P(P_tree[5][i-15]),       .G(G_tree[5][i-15])
        );
    end
endgenerate
    
    assign sum[0] = G_tree[0][0] ^ a[0] ^ b[0];
    
generate
    for(i = 16; i < 32; i++) begin: sum_grp5
        assign sum[i] = G_tree[5][i] ^ a[i] ^ b[i];
    end
    for(i = 8; i < 16; i++) begin: sum_grp4
        assign sum[i] = G_tree[4][i] ^ a[i] ^ b[i];
    end
    for(i = 4; i < 8; i++) begin: sum_grp3
        assign sum[i] = G_tree[3][i] ^ a[i] ^ b[i];
    end
    for(i = 2; i < 4; i++) begin: sum_grp2
        assign sum[i] = G_tree[2][i] ^ a[i] ^ b[i];
    end
    for(i = 1; i < 2; i++) begin: sum_grp1
        assign sum[i] = G_tree[1][i] ^ a[i] ^ b[i];
    end
endgenerate

    assign cout = G_tree[5][31] & (a[31] ^ b[31]) | (a[31] & b[31]);
    
endmodule
