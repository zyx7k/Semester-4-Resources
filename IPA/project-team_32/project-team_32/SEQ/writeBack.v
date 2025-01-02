module write_back (
    clk, icode, rA, rB, valE, valM, register0, register1, register2,
    register3, register4, register5, register6, register7, register8,
    register9, register10, register11, register12, register13, register14
);

input clk;
input [3:0] icode, rA, rB;
input [63:0] valE, valM;

output reg [63:0] register0;
output reg [63:0] register1;
output reg [63:0] register2;
output reg [63:0] register3;
output reg [63:0] register4;
output reg [63:0] register5;
output reg [63:0] register6;
output reg [63:0] register7;
output reg [63:0] register8;
output reg [63:0] register9;
output reg [63:0] register10;
output reg [63:0] register11;
output reg [63:0] register12;
output reg [63:0] register13;
output reg [63:0] register14;

reg [63:0] memReg [0:14];

integer k;

initial begin
    for(k=0; k<15; k=k+1) begin
        memReg[k] = 64'd0;
    end
end

always @(*)
    begin
        case(icode)

        //Write back not required for
            // -->nop -->halt

        //cmovXX
        4'b0010: begin memReg[rB] = valE; end

        //irmovq
        4'b0011: begin memReg[rB] = valE; end

        //rmmovq
            //Do nothing

        //mrmovq
        4'b0101: begin memReg[rA] = valM; end

        //OPq
        4'b0110: begin memReg[rB] = valE; end

        //jXX
            //Do nothing

        //call
        4'b1000: begin memReg[4'b0100] = valE; end //%rsp is the 4th register

        //ret
        4'b1001: begin memReg[4'b0100] = valE; end //%rsp is the 4th register

        //pushq
        4'b1010: begin memReg[4'b0100] = valE; end //%rsp is the 4th register

        //popq
        4'b1011: begin
            memReg[4'b0100] = valE; //%rsp is the 4th register
            memReg[rA] = valM;
            end

        endcase

    end

always @(*) begin

    register0 = memReg[0];
    register1 = memReg[1];
    register2 = memReg[2];
    register3 = memReg[3];
    register4 = memReg[4];
    register5 = memReg[5];
    register6 = memReg[6];
    register7 = memReg[7];
    register8 = memReg[8];
    register9 = memReg[9];
    register10 = memReg[10];
    register11 = memReg[11];
    register12 = memReg[12];
    register13 = memReg[13];
    register14 = memReg[14];

end

endmodule