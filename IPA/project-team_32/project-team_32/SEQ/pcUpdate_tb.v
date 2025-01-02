`include "pcUpdate.v"
`timescale 1ns / 1ns

module pcUpdate_tb;

// Testbench Variables
reg [3:0] icode;
reg cnd;
reg [63:0] valC, valM, valP;
wire [63:0] updatedPC; //Initially, PC = 2 (see pcUpdate module file)

pcUpdate uut (
    .icode(icode),
    .cnd(cnd),
    .clk(clk),
    .valC(valC),
    .valM(valM),
    .valP(valP),
    .updatedPC(updatedPC)
);

// Clock generation
reg clk = 0;
always #5 clk = ~clk;

initial begin
    
    //Initialization
    icode = 4'b0001; // Default nop --> Won't affect the PC value
    cnd = 0; 
    valC = 64'd0;
    valM = 64'd1;
    valP = 64'd2; // nop won't change valP
    #10

    // Test Case 1: cmovXX rA, rB instruction --> PC = PC + 2
    icode = 4'b0010; valP = 64'd4;
    #10;

    // Test Case 2: irmovq V, rB instruction --> PC = PC + 10
    icode = 4'b0011; valP = 64'd14;
    #10;

    // Test Case 3: rmmovq rA, D(rB) instruction --> PC = PC + 10
    icode = 4'b0100; valP = 64'd24;
    #10

    // Test Case 4: mrmovq D(rB), rA instruction --> PC = PC + 10
    icode = 4'b0101; valP = 64'd34;
    #10

    // Test Case 5: OPq rA, rB instruction --> PC = PC + 2
    icode = 4'b0110; valP = 64'd36;
    #10

    // Test Case 6: jXX Dest instruction
    // Assuming Test Case 5 sets the CC to 0, then the jump is not taken --> PC = PC + 9
    cnd = 1'b0; icode = 4'b0111;
    valC = 64'd50; valP = 64'd45;
    #10

    // Test Case 7: OPq rA, rB instruction --> PC = PC + 2
    icode = 4'b0110; valP = 64'd47; 
    #10

    // Test Case 8: jXX Dest instruction
    // Assuming Test Case 7 sets the CC to 1, then the jump is taken --> PC = valC
    cnd = 1'b1; icode = 4'b0111;
    valC = 64'd100; //PC is now set to 100
    valP = 64'd56; //valP will be incremented by 9 because of jXX instruction length
    #10

    // Test Case 9: call instruction
    // The last test case, PC was set to valC i.e, 100.
    // Now in this cycle, fetch had set valP = PC + 9 which is 100+0=109
    cnd = 1'b0; icode = 4'b1000; valC = 64'd150; //PC is now set to 150
    valP = 64'd109;
    #10

    // Test Case 10: ret instruction --> PC = PC + 1
    // The last test case, PC was set to valC i.e, 150.
    // Now in this cycle, fetch had set valP = PC + 1 which is 150+1=151
    icode = 4'b1001; valM = 64'd109;
    valP = 64'd151;
    #10
    
    // Test Case 11: pushq rA instruction --> PC = PC + 2
    // The last test case, PC was set to valM i.e, 159.
    // Now in this cycle, fetch had set valP = PC + 1 which is 109+21=111
    icode = 4'b1010; valP = 64'd111;
    #10

    // Test Case 12: popq rA instruction --> PC = PC + 2
    // The last test case, PC was set to valP i.e, 111.
    // Now in this cycle, fetch had set valP = PC + 1 which is 111+2=113
    icode = 4'b1011; valP = 64'd113;
    #10

    // Test Case 13: halt instruction --> PC = PC + 1
    // Program Teriminates
    icode = 4'b0000; valP = 64'd114; 

    #10;
    $finish;
end

// Record changes
initial begin
    $monitor("Time = %d, icode = %b, cnd = %b, valC = %d, valM = %d, valP = %d, updatedPC = %d", $time, icode, cnd, valC, valM, valP, updatedPC);
    $dumpfile("pcUpdate_dumpfile.vcd");
    $dumpvars(0 , uut);
end

endmodule
