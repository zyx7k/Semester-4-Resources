`include "ADDER_op.v"
`include "AND_op.v"
`include "XOR_op.v"

module alu(
    input [63:0] A,
    input [63:0] B,
    input S0,
    input S1,
    output [63:0] Output,
    output Overflow
);

    wire s0,s1,D0,D1,D2,D3,P,C_in;
    wire [63:0] A_Adder_Subtractor;
    wire [63:0] B_Adder_Subtractor;
    wire [63:0] B_dash;
    wire [63:0] A_XOR;
    wire [63:0] B_XOR;
    wire [63:0] A_And;
    wire [63:0] B_And;
    wire [63:0] Adder_Subtractor;
    wire C_out;

    wire [63:0] And;  
    wire [63:0] Xor; 

    //Decoder
    not gate1(s0, S0);
    not gate2(s1, S1);
    and gate3(D0, s1, s0);
    and gate4(D1, s1, S0);
    and gate5(D2, S1, s0);
    and gate6(D3, S1, S0);
    assign C_in = D1;     // M

    or gate7(P, D0, D1);

    //Enabler
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin
            and gate(A_Adder_Subtractor[i], P, A[i]);
        end
    endgenerate


    generate
        for (i=0; i<64; i=i+1) begin
            and gate(B_Adder_Subtractor[i], P, B[i]);
        end
    endgenerate


    generate
        for (i=0; i<64; i=i+1) begin
            and gate(A_And[i], D2, A[i]);
        end
    endgenerate


    generate
        for (i=0; i<64; i=i+1) begin
            and gate(B_And[i], D2, B[i]);
        end
    endgenerate

   
    generate
        for (i=0; i<64; i=i+1) begin
            and gate(A_XOR[i], D3, A[i]);
        end
    endgenerate

    
    generate
        for (i=0; i<64; i=i+1) begin
            and gate(B_XOR[i], D3, B[i]);
        end
    endgenerate

    
    generate
        for (i=0; i<64; i=i+1) begin
            xor gate(B_dash[i], C_in, B_Adder_Subtractor[i]);
        end
    endgenerate


    ADDER_op U0 (.A(A_Adder_Subtractor), .B(B_dash), .Cin(C_in), .S(Adder_Subtractor), .Cout(C_out));
    AND_op U1 (.A(A_And), .B(B_And), .AND_OUT(And));
    XOR_op U2 (.A(A_XOR), .B(B_XOR), .XOR_OUT(Xor));
    

   
    generate
        for (i=0; i<64; i=i+1) begin
            or gate(Output[i], Adder_Subtractor[i], And[i], Xor[i]);
        end
    endgenerate

    assign Overflow = C_out;



endmodule