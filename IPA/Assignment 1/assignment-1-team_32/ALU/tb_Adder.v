module Adder_tb;

  // Inputs
  reg [63:0] A;
  reg [63:0] B;
  reg Cin;

  // Outputs
  wire [63:0] S;
  wire Cout;

  ADDER_op uut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );


initial $monitor("A = %b, \nB = %b, \nS = %b, \nCout = %b\n\n",A,B,S,Cout);

  initial begin
    $dumpfile("Adder_op.vcd");
    $dumpvars(0, Adder_tb);
    // Initialize inputs
    A = 2;
    B = 3;
    Cin = 0;
    #10

    A = 7;
    B = 8;
    Cin = 0;
    #10

    A = 2**63-1;
    B =  1; 
    Cin = 0;
    #10

    A = -(2**63);
    B =  -1; 
    Cin = 0;
    #10

    $finish;
  
  end

endmodule
