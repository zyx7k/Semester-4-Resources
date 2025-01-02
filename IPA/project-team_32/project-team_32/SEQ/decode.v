module decode (
    input clk,
    input [3:0] icode,
    input [3:0] ifun,
    input [3:0] rA,
    input [3:0] rB,
    input instructionValid,
    input [63:0] valE, 
    input [63:0] valM,
    input cnd,
    output reg [63:0] valA,
    output reg [63:0] valB,
    output reg [63:0] register0,
    output reg [63:0] register1,
    output reg [63:0] register2,
    output reg [63:0] register3,
    output reg [63:0] register4,
    output reg [63:0] register5,
    output reg [63:0] register6,
    output reg [63:0] register7,
    output reg [63:0] register8,
    output reg [63:0] register9,
    output reg [63:0] register10,
    output reg [63:0] register11,
    output reg [63:0] register12,
    output reg [63:0] register13,
    output reg [63:0] register14
);

reg [63:0] memReg [0:14];



initial 
begin
    valA = 0;
    valB = 0;
    memReg[0] = 64'd1;    
    memReg[1] = 64'd2;    
    memReg[2] = 64'd3;    
    memReg[3] = 64'd4;    
    memReg[4] = 64'd154;    // Rsp
    memReg[5] = 64'd0;    
    memReg[6] = 64'd0;    
    memReg[7] = 64'd0;    
    memReg[8] = 64'd0;    
    memReg[9] = 64'd0;    
    memReg[10] = 64'd0;    
    memReg[11] = 64'd0;    
    memReg[12] = 64'd0;    
    memReg[13] = 64'd0;    
    memReg[14] = 64'd0;    

end


// decode
always @(*)
begin

    case (icode)
        4'd0, 4'd1: // halt, nop
        begin
            // T.B.D
        end

        4'd2: // cmovXX rA, rB
        begin
            valA = memReg[rA];
            valB = memReg[rB];
        end

        4'd3: // irmovq
        begin
            valB = 64'd0;
        end

        4'd4, 4'd6: // rmmovq & OPq rA, rB
        begin
            valA = memReg[rA];
            valB = memReg[rB];
        end

        4'd5: // mrmovq
        begin
            valB = memReg[rB];
        end

        4'd8: // call
        begin
            valB = memReg[4];
        end

        4'd9, 4'd11: // ret & popq
        begin
            valA = memReg[4];
            valB = memReg[4];
        end

        4'd10: // pushq
        begin
            valA = memReg[rA];
            valB = memReg[4];
        end
    endcase

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



// writeback
always @(posedge clk)
    begin
        case(icode)
        //Write back not required for
            // -->nop -->halt

        //cmovXX
        4'b0010: 
        begin
            if (cnd==1)
            begin
                memReg[rB] = valE; 
            end
        end

        //irmovq
        4'b0011: 
        begin 
            memReg[rB] = valE; 
        end

        //rmmovq
            //Do nothing

        //mrmovq
        4'b0101: 
        begin 
            memReg[rA] = valM; 
        end

        //OPq
        4'b0110: 
        begin 
            memReg[rB] = valE; 
        end

        //jXX
            //Do nothing

        //call
        4'b1000: 
        begin 
            memReg[4'b0100] = valE; //%rsp is the 4th register
        end 

        //ret
        4'b1001: 
        begin 
            memReg[4'b0100] = valE; //%rsp is the 4th register
        end 

        //pushq
        4'b1010: 
        begin 
            memReg[4'b0100] = valE; //%rsp is the 4th register
        end 

        //popq
        4'b1011: 
        begin
            memReg[4'b0100] = valE; //%rsp is the 4th register
            memReg[rA] = valM;
        end

        endcase
        
           
    end

always @(*)
begin
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
