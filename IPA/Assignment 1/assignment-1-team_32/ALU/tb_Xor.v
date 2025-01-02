module Xor_tb;

  // Inputs
  reg [63:0] A;
  reg [63:0] B;

  // Output
  wire [63:0] XOR_OUT;

  XOR_op uut (
    .A(A),
    .B(B),
    .XOR_OUT(XOR_OUT)
  );


initial $monitor("A = %b, \nB = %b, \nOut = %b,\n",A,B,XOR_OUT);

  initial begin
    $dumpfile("XOR_op.vcd");
    $dumpvars(0, Xor_tb);
    // Initialize inputs

    A = 19; B = 23; #10
    A = 25; B = 72; #10
    A = -12; B = -13; #10

    $finish;

  end

endmodule
