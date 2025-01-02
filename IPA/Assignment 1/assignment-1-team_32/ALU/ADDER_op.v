`include "full_adder.v"
module ADDER_op(
    input [63:0]A,
    input [63:0]B,
    input Cin,
    output [63:0] S,
    output Cout
);

wire [64:0] C;
assign C[0] = Cin;

genvar i;
generate
    for (i=0; i<64; i=i+1) begin
        full_adder inst (.A(A[i]), .B(B[i]), .C0(C[i]), .Sum(S[i]), .Carry(C[i+1]));
    end
endgenerate

xor gate (Cout, C[64], C[63]);

endmodule