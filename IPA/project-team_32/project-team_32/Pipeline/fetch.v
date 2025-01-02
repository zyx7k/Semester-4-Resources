`include "selectPC.v"
`include "predictPC.v"

module fetch(
    F_predPC, M_icode, M_cnd, M_valA, W_icode, W_valM,
    f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_stat
);

input [63:0] F_predPC, M_valA, W_valM;
input [3:0] M_icode, W_icode;
input M_cnd;

output reg [3:0] f_icode, f_ifun, f_rA, f_rB;
output reg [63:0] f_valC, f_valP;
output [63:0] f_predPC;
output reg [2:0] f_stat;

//Initalize Instruction Memory
reg [7:0] instructionMemory [0:127]; 

initial begin
    //Read the testcase
    $readmemb("testcase.txt", instructionMemory);
end

wire [63:0] f_pc; 

//Call the two other modules

selectPC select(.M_icode(M_icode), .M_cnd(M_cnd), .M_valA(M_valA), .W_icode(W_icode), .W_valM(W_valM), .F_predPC(F_predPC), .f_pc(f_pc));

predictPC predict(.f_icode(f_icode), .f_valC(f_valC), .f_valP(f_valP), .f_predPC(f_predPC));

//Creating wires for instructionValid and imemError and others
reg instructionValid, imemError;
reg [0:7] instruction;
reg [0:7] regrArB;

always @(*)
begin 

    if(f_pc < 0 || f_pc > 127) // Max PC value is taken at my discretion to be 127
    begin
        f_icode <= 1'b1;
        f_ifun <= 1'b0;
        imemError <= 1'b1;
    end

    else 
    begin
        //Extracting Information about instruction
        //Default Values
        instruction <= {instructionMemory[f_pc]};
        f_icode <= instruction[0:3];
        f_ifun <= instruction[4:7];
        imemError <= 1'b0;
    end
end

always @(*)
begin 
    if((f_icode < 4'b000) && (f_icode > 4'b1011))
    begin 
        instructionValid = 1'b0; 
    end

    else
    begin instructionValid = 1'b1; end
end

always @(*)
begin
    // Fetch based on f_icode

        if ((f_icode == 4'b0001) || (f_icode == 4'b1001)) //ret
        begin
            f_valP = f_pc + 1;
        end

        else if ((f_icode == 4'b0010) || (f_icode == 4'b0110) || (f_icode == 4'b1010) || (f_icode == 4'b1011)) //cmovXX, OPq, pushq & popq
        begin
            regrArB = {instructionMemory[f_pc+1]};
            f_rA = regrArB[0:3];
            f_rB = regrArB[4:7];
            f_valP = f_pc + 2;
            f_valC = 0;
        end

        else if (f_icode == 4'b0011 || f_icode == 4'b0100 || f_icode == 4'b0101) //irmovq, rmmovq & mrmovq
        begin
            regrArB = {instructionMemory[f_pc+1]};
            f_rA = regrArB[0:3];
            f_rB = regrArB[4:7];
            f_valC = { instructionMemory[9+f_pc], instructionMemory[8+f_pc], instructionMemory[7+f_pc], instructionMemory[6+f_pc], instructionMemory[5+f_pc], instructionMemory[4+f_pc], instructionMemory[3+f_pc], instructionMemory[2+f_pc]};
            f_valP = f_pc + 10;
        end

        else if (f_icode == 4'b0111 || f_icode == 4'b1000) // jXX Dest & call Dest
        begin
            f_valC = { instructionMemory[8+f_pc], instructionMemory[7+f_pc], instructionMemory[6+f_pc], instructionMemory[5+f_pc], instructionMemory[4+f_pc], instructionMemory[3+f_pc], instructionMemory[2+f_pc], instructionMemory[1+f_pc]};
            f_valP = f_pc + 9;
        end

        else 
        begin
            f_rA = 15;
            f_rB = 15;
            f_valP = f_pc + 1;
        end
end

always @(*)
begin
    
    if(f_icode == 0)
    begin f_stat = 2; end // HLT

    else if(imemError == 1)
    begin f_stat = 3; end // ADR

    else if(instructionValid == 0)
    begin f_stat = 4; end // INS

    else
    begin f_stat = 1; end // AOK (Normal Operation)
end

endmodule