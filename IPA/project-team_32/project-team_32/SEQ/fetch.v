module fetch (
    input clk,
    input [63:0] PC,
    output reg [3:0] icode,
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC,
    output reg [63:0] valP,
    output reg halt,
    output reg instructionValid,
    output reg imemError
);

reg [7:0] instructionMemory [0:127]; 

//Extracting Information about instruction
reg [0:7] instruction;
reg [0:7] regrArB;

initial begin
    //Read the testcase
    $readmemb("1.txt", instructionMemory);
end

always @(*)
begin

    // Default initialization values
    instructionValid = 1'b1;
    imemError = 1'b0;
    halt = 1'b0;
    
    // Check for instruction memory error
    if (PC > 127) 
    begin
        imemError = 1'b1;
    end

    //Extracting Information about instruction
    instruction = {instructionMemory[PC]};
    icode = instruction[0:3];
    ifun = instruction[4:7];

    if((icode < 4'b000) && (icode > 4'b1011))
    begin 
        instructionValid = 1'b0; 
    end

    else 
    begin

        // Decode based on icode

        if (icode == 4'b0000) //halt
        begin
            halt = 1;
            valP = PC + 1;
        end
        
        else if ((icode == 4'b0001) || (icode == 4'b1001)) //nop & ret
        begin
            valP = PC + 1;
        end

        else if ((icode == 4'b0010) || (icode == 4'b0110) || (icode == 4'b1010) || (icode == 4'b1011)) //cmovXX rA, rB & OPq rA, rB
        begin
            regrArB = {instructionMemory[PC+1]};
            rA = regrArB[0:3];
            rB = regrArB[4:7];
            valP = PC + 2;
        end

        else if (icode == 4'b0011 || icode == 4'b0100 || icode == 4'b0101) //irmovq V, rB & rmmovq rA, D(rB) & mrmovq D(rB), rA & pushq rA & popq rA
        begin
            regrArB = {instructionMemory[PC+1]};
            rA = regrArB[0:3];
            rB = regrArB[4:7];
            valC = { instructionMemory[9+PC], instructionMemory[8+PC], instructionMemory[7+PC], instructionMemory[6+PC], instructionMemory[5+PC], instructionMemory[4+PC], instructionMemory[3+PC], instructionMemory[2+PC]};
            valP = PC + 10;
        end

        else if (icode == 4'b0111 || icode == 4'b1000) // jXX Dest & call Dest
        begin
            valC = { instructionMemory[8+PC], instructionMemory[7+PC], instructionMemory[6+PC], instructionMemory[5+PC], instructionMemory[4+PC], instructionMemory[3+PC], instructionMemory[2+PC], instructionMemory[1+PC]};
            valP = PC + 9;
        end

    end
end
endmodule