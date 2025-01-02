module And_tb;

  // Inputs
  reg [63:0] A;
  reg [63:0] B;

  // Output
  wire [63:0] AND_OUT;
  
  AND_op uut (
    .A(A),
    .B(B),
    .AND_OUT(AND_OUT)
  );


initial $monitor("A = %b, \nB = %b, \nOut = %b,\n",A,B,AND_OUT);

  initial begin
    $dumpfile("AND_op.vcd");
    $dumpvars(0, And_tb);

    // Initialize inputs
    A = 8; B = 7; #10
    A = 18; B = 19; #10
    A = -12; B = -13; #10

    $finish; 

  end

endmodule
