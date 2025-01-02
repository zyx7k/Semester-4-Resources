`include "writeBack.v"
`timescale 1ns / 1ns

module writeBack_tb;

//Testbench variables
reg [3:0] icode, rA, rB;
reg [63:0] valE, valM;

wire [63:0] register0, register1, register2, register3, register4, register5, register6, register7, register8, register9, register10, register11, register12, register13, register14;

write_back uut (
    .clk(clk), .icode(icode), .rA(rA), .rB(rB), .valE(valE), .valM(valM), .register0(register0), .register1(register1), .register2(register2),
    .register3(register3), .register4(register4), .register5(register5),.register6(register6), .register7(register7), .register8(register8),
    .register9(register9), .register10(register10), .register11(register11), .register12(register12), .register13(register13), .register14(register14)
);

// Clock generation
reg clk = 0;
always #5 clk = ~clk;

initial begin

    //Initialization
    icode = 4'b0001; // Default nop --> Won't affect the PC value
    valE = 64'd100;
    valM = 64'd200;
    rA = 4'b1100;
    rB = 4'b0101;
    #10

    // Test Case 1: cmovXX rA, rB instruction --> R[rB] = valE
    icode = 4'b0010; valE = 64'd90; //Write valE to rB = 4'b0101
    #10;

    // Test Case 2: irmovq V, rB instruction --> R[rB] = valE
    icode = 4'b0011; rB = 4'b0110; valE = 64'd80; //Write valE to rB = 4'b0110
    #10;

    // Test Case 3: rmmovq rA, D(rB) instruction --> Do nothing
    icode = 4'b0100; valE = 64'd70; //Won't change anything
    #10

    // Test Case 4: mrmovq D(rB), rA instruction --> R[rA] = valM
    icode = 4'b0101; valM = 64'd190; //Write valM to rA = 4'b1100;
    #10

    // Test Case 5: OPq rA, rB instruction --> R[rB] = valE
    icode = 4'b0110; valE = 64'd60; //Write valE to rB = 4'b0110
    #10

    // Test Case 6: jXX Dest instruction --> Do nothing
    icode = 4'b0111; valE = 64'd50; valM = 64'd180; //Won't change anything
    #10

    // Test Case 7: call instruction -->R[%rsp] = valE
    icode = 4'b1000; valE  = 64'd40; //Write valE to %rsp register
    #10

    // Test Case 8: ret instruction --> R[%rsp] = valE
    icode = 4'b1001; valE = 64'd30; //Write valE to %rsp register
    #10
    
    // Test Case 9 pushq rA instruction --> R[%rsp] = valE
    icode = 4'b1010; valE = 64'd20; //Write valE to %rsp register
    #10

    // Test Case 10: popq rA instruction --> R[%rsp] = valE & R[rA] = valM
    icode = 4'b1011; rA = 4'b1110; valE = 64'd10; valM = 64'd140; //Write valE to %rsp register & valM to R[rA]
    #10

    // Test Case 11: halt instruction
    // Program Teriminates
    icode = 4'b0000; 
    
    #10;
    $finish;

end

// Record changes
initial begin
    $monitor("Time = %d, icode = %b, rA = %d, rB = %d, valE = %d, valM = %d \n register0 = %d, register1 = %d, register2 = %d, register3 = %d, register4 = %d, register5 = %d, register6 = %d, register7 = %d, register8 = %d, register9 = %d, register10 = %d, register11 = %d, register12 = %d, register13 = %d, register14 = %d", $time, icode, rA, rB, valE, valM, register0, register1, register2, register3, register4, register5, register6, register7, register8, register9, register10, register11, register12, register13, register14);
    $dumpfile("writeBack_dumpfile.vcd");
    $dumpvars(0 , uut);
end

endmodule