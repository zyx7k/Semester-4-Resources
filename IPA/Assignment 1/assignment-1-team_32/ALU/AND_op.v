module AND_op(
    input [63:0]A,
    input [63:0]B,
    output [63:0] AND_OUT
);


genvar i;
generate
    for (i=0; i<64; i=i+1) begin
        and gate(AND_OUT[i], A[i], B[i]);
    end
endgenerate

endmodule