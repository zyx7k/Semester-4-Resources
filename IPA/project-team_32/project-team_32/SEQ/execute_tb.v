`timescale 10ns/1ps

module execute_tb;

initial begin
    $dumpfile("execute_tb.vcd");
    $dumpvars(0, execute_tb);
end

reg signed clk;
reg signed [3:0] icode;
reg signed [3:0] ifun;
reg signed [63:0] valA;
reg signed [63:0] valB;
reg signed [63:0] valC;      // offset
wire signed [63:0] valE;
wire cnd;


execute e1(
    .clk(clk),
    .icode(icode),
    .ifun(ifun),
    .valA(valA),
    .valB(valB),
    .valC(valC),
    .valE(valE),
    .cnd(cnd)    
);

parameter CLOCK_PER = 10;
initial 
begin
    clk = 0;
end
always #CLOCK_PER 
begin
    clk = ~clk;    
end


initial begin
    icode = 4'd6; ifun = 4'd0; valA = 64'd15; valB = 64'd10; valC = 64'd0; #10;
    ifun = 4'd1; valB = 64'd15; valA = 64'd10; #10;
    ifun = 4'd2; valB = 64'd15; valA = 64'd15; #10;
    ifun = 4'd3; valB = 64'd15; valA = 64'd15; #10;
    ifun = 4'd1; valB = 64'd10; valA = 64'd15; #10;
    ifun = 4'd0; valB = 9223372036854775807;  valA = 2; #10;
    ifun = 4'd1; valB = -9223372036854775807; valA = 3; #10;
    ifun = 4'd2; valB = 64'd1; valA = 64'd1; #10;
    icode = 4'd4; valA = 64'd10; valB = 64'd11; valC = 64'd13; #10;
    icode = 4'd6; ifun = 4'd1; valB = 64'd10; valA = 64'd15; valC = 64'd10; #10;
    icode = 4'd2; ifun = 4'd1; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd6; ifun = 4'd1; valB = 64'd15; valA = 64'd15; valC = 64'd10; #10;
    icode = 4'd2; ifun = 4'd0; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd1; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd2; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd3; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd4; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd5; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd2; ifun = 4'd6; valB = 64'd10; valA = 64'd1; #10;
    icode = 4'd3; ifun = 4'd0; valC = 64'd1000;
    $finish;
end

initial begin
    $monitor("icode = %d, ifun = %d, valA = %d, valB = %d, out = %d, cnd = %d", icode, ifun, valA, valB, valE, cnd);
end


endmodule