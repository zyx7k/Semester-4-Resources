module XOR_op(
    input [63:0]A,
    input [63:0]B,
    output [63:0] XOR_OUT
);


genvar i;
generate
    for (i=0; i<64; i=i+1) begin
        xor gate(XOR_OUT[i], A[i], B[i]);
    end
endgenerate

endmodule