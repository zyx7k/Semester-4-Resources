`timescale 1ns/1ns
`include "fetch.v"

module fetch_tb;

initial 
begin
    $dumpfile("fetch_dumpfile.vcd");
    $dumpvars(0, fetch_tb);    
end

reg clk;
reg [63:0] PC;
wire [3:0] icode;
wire [3:0] ifun;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valC;
wire [63:0] valP;
wire halt;
wire instructionValid;
wire imemError;

fetch f1
(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP),
    .halt(halt),
    .instructionValid(inst_valid),
    .imemError(imemError)
);

initial
    clk = 0;

parameter CLOCK_PER = 10;
always #CLOCK_PER
begin
    clk = ~clk;
end

initial 
begin 
    PC = 64'd0;
    #100;
    $finish;
end 

always @(posedge clk)
begin
    PC = valP;
end

initial
begin
    $monitor("PC = %d, icode = %d, ifun = %d, valC = %d, valP = %d, rA = %d, rB = %d", PC, icode, ifun, valC, valP, rA, rB);
end
endmodule