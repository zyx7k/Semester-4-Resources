`timescale 1ns/1ps

module decode_tb;

  reg clk;
  reg [3:0] icode;
  reg [3:0] ifun;
  reg [3:0] rA;
  reg [3:0] rB;
  reg instructionValid;
  reg [63:0] valE; 
  reg [63:0] valM;
  reg cnd;
  wire [63:0] valA;
  wire [63:0] valB;
  wire [63:0] register0;
  wire [63:0] register1;
  wire [63:0] register2;
  wire [63:0] register3;
  wire [63:0] register4;
  wire [63:0] register5;
  wire [63:0] register6;
  wire [63:0] register7;
  wire [63:0] register8;
  wire [63:0] register9;
  wire [63:0] register10;
  wire [63:0] register11;
  wire [63:0] register12;
  wire [63:0] register13;
  wire [63:0] register14;
  

  // Instantiate the decode module
  decode uut (
    .clk(clk),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .instructionValid(instructionValid),
    .valE(valE),
    .valM(valM),
    .cnd(cnd),
    .valA(valA),
    .valB(valB),
    .register0(register0),
    .register1(register1),
    .register2(register2),
    .register3(register3),
    .register4(register4),
    .register5(register5),
    .register6(register6),
    .register7(register7),
    .register8(register8),
    .register9(register9),
    .register10(register10),
    .register11(register11),
    .register12(register12),
    .register13(register13),
    .register14(register14)
  );

  // Clock generation
  initial begin
    clk = 0;

    #10 clk = ~clk;

    icode = 4'b0010; //cmov

    ifun = 4'b0000;
    rA = 4'b0000;
    rB = 4'b0001;
    instructionValid = 1;
    valE = 64'd1;
    valM = 64'd0;
    cnd=1;

    #10 clk = ~clk;

    icode = 4'b0010; //cmov

    ifun = 4'b0000;
    rA = 4'b0000;
    rB = 4'b0001;
    instructionValid = 1;
    valE = 64'd1;
    valM = 64'd0;
    cnd=1;

    #10 clk = ~clk;

    icode = 4'b0010; //cmov

    ifun = 4'b0000;
    rA = 4'b0000;
    rB = 4'b0001;
    instructionValid = 1;
    valE = 64'd1;
    valM = 64'd0;
    cnd=1;
    #10 clk = ~clk;

    icode = 4'b0010; //cmov

    ifun = 4'b0000;
    rA = 4'b0000;
    rB = 4'b0001;
    instructionValid = 1;
    valE = 64'd5;
    valM = 64'd0;
    cnd=1;

  end

  initial
  begin
    $monitor("clk = %d, icode = %d, rA = %d, rB = %d, valA = %d, valB = %d\n",clk,icode,rA,rB,valA,valB);
  end


  

endmodule
