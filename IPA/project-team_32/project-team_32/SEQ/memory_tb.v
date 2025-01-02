`include "memory.v"
`timescale 1ns / 1ns

module memory_tb;

// Testbench Variables
reg [3:0] icode;
reg [63:0] valA, valE, valP;

wire [63:0] valM;
wire dmem_error;

memory uut (
    .icode(icode), .clk(clk), .valA(valA), .valE(valE), .valM(valM), .valP(valP), .dmem_error(dmem_error)
);

// Clock generation
reg clk = 0;
always #5 clk = ~clk;

initial begin

    //Initialization
    icode = 4'b0001; // Default nop --> Won't affect the PC value
    valA = 64'd0;
    valE = 64'd0;
    valP = 64'd0;
    #10

    // Test Case 1: cmovXX rA, rB instruction --> Do nothing
    icode = 4'b0010;
    #10;

    // Test Case 2: irmovq V, rB instruction --> Do nothing
    icode = 4'b0011;
    #10;

    // Test Case 3: rmmovq rA, D(rB) instruction --> M[valE] = valA
    icode = 4'b0100; valE = 64'd100; valA = 64'd1000;
    #10

    // Test Case 4: mrmovq D(rB), rA instruction --> valM = M[valE]
    icode = 4'b0101; valE = 64'd100; //ValM will be set to 1000
    #10

    // Test Case 5: OPq rA, rB instruction --> Do nothing
    icode = 4'b0110;
    #10

    // Test Case 6: jXX Dest instruction --> Do nothing
    icode = 4'b0111;
    #10

    // Test Case 7: call instruction --> M[valE] = valP
    icode = 4'b1000; valE  = 64'd200; valP = 64'd2000; 
    #10

    // Test Case 8: ret instruction --> valM = M[valA]
    icode = 4'b1001; valA = 64'd100; 
    #10
    
    // Test Case 9: pushq rA instruction --> M[valE] = valA
    icode = 4'b1010; valE = 64'd69; valA = 64'd420;
    #10

    // Test Case 10: popq rA instruction --> valM = M[valA]
    icode = 4'b1011; valA = 64'd200;
    #10

    // Test Case 11: Raise dmem_error
    icode = 4'b0100; valE = 64'd420; valA = 64'd69;
    #10

    // Test Case 12: halt instruction
    // Program Teriminates
    icode = 4'b0000; 
    
    #10;
    $finish;

end

// Record changes
initial begin
    $monitor("Time = %d, icode = %b, valA = %d, valE = %d, valP = %d, valM = %d, dmem_error = %d", $time, icode, valA, valE, valP, valM, dmem_error);
    $dumpfile("memory_dumpfile.vcd");
    $dumpvars(0 , uut);
end

endmodule