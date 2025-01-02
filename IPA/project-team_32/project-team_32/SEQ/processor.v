`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "pcUpdate.v"
`include "memory.v"


module processor;

// fetch
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

// decode
wire signed [63:0] valE;
wire signed [63:0] valM;
wire cnd;
wire signed [63:0] valA;
wire signed [63:0] valB;
wire signed [63:0] register0;
wire signed [63:0] register1;
wire signed [63:0] register2;
wire signed [63:0] register3;
wire signed [63:0] register4;
wire signed [63:0] register5;
wire signed [63:0] register6;
wire signed [63:0] register7;
wire signed [63:0] register8;
wire signed [63:0] register9;
wire signed [63:0] register10;
wire signed [63:0] register11;
wire signed [63:0] register12;
wire signed [63:0] register13;
wire signed [63:0] register14;

// execute


// memory
wire dmem_error;

// pcUpdate
wire [63:0] updatedPC;


fetch block1( .clk(clk), .PC(PC), .icode(icode),
              .ifun(ifun), .rA(rA), .rB(rB), .valC(valC), 
              .valP(valP), .halt(halt), 
              .instructionValid(instructionValid), 
              .imemError(imemError)
            );

// Rrsp = register4 from writeBack
decode block2( .clk(clk), .icode(icode), .ifun(ifun),
               .rA(rA), .rB(rB), 
               .instructionValid(instructionValid),
               .valE(valE), .valM(valM), .cnd(cnd),
               .valA(valA), .valB(valB),
               .register0(register0), .register1(register1),
               .register2(register2), .register3(register3),
               .register4(register4), .register5(register5),
               .register6(register6), .register7(register7),
               .register8(register8), .register9(register9),
               .register10(register10), .register11(register11),
               .register12(register12), .register13(register13),
               .register14(register14)             
             );


execute block3( .clk(clk), .icode(icode), .ifun(ifun),
                .valA(valA), .valB(valB), .valC(valC),
                .valE(valE), .cnd(cnd)
              );


memory block4( .clk(clk), .icode(icode),
                .valA(valA), .valE(valE), .valP(valP), 
                .valM(valM), .dmem_error(dmem_error)
             );

pcUpdate block5( .clk(clk), .cnd(cnd), .icode(icode),
                 .valC(valC), .valM(valM), .valP(valP),
                 .updatedPC(updatedPC)
               );


initial 
begin
    $dumpfile("processor_tb.vcd");
    $dumpvars(0, processor);  
end

initial 
begin

    clk = 0;
    PC = 64'd0;

    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = updatedPC;
    #10 clk = ~clk; 

end

initial
$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d\t valM=%d valP=%d cnd=%d halt=%d\n", clk, PC, icode, ifun, rA, rB, valA, valB, valC, valE, valM, valP, cnd, halt);
endmodule