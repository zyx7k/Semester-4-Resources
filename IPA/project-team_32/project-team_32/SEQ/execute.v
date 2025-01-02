`include "ALU.v"

module execute (
    input clk,
    input [3:0] icode,
    input [3:0] ifun,
    input [63:0] valA,
    input [63:0] valB,
    input [63:0] valC,

    output reg [63:0] valE, //valE is the output of the execute stage
    output reg cnd //cnd is also an output of the execute stage
);

reg signed [63:0] A_input;
reg signed [63:0] B_input;

wire signed [63:0] ALU_Output; //ALU_Circuit is internal to the circuit, so it is a wire.

wire overflow;
reg [1:0] select_lines;

reg ZF, SF, OF;

alu alu1(.A(A_input), .B(B_input), .S0(select_lines[0]), .S1(select_lines[1]), .Output(ALU_Output), .Overflow(overflow));

initial begin
    select_lines[0] = 1'b0;
    select_lines[1] = 1'b0;
    valE = 64'd0;
    ZF = 1'b0;
    SF = 1'b0;
    OF = 1'b0;
    A_input = 64'd0;
    B_input = 64'd0;
    cnd = 1'b0;
end

always @(*)
begin

    //Reset cnd
    cnd = 1'b0;

    // Perform operations based on icode
    case (icode)

        4'd0, 4'd1: begin end // do nothing

        4'd2: // cmovXX rA, rB
    
            //Since this is Y-86, we only have [zf, sf, of] (in this order) to work with.
            //That leaves us with the six conditional move instructions: 

            // 1. cmovle (SF ^ OF) | ZF
            // 2. cmovl SF ^ OF
            // 3. cmove ZF
            // 4. cmovne ~ZF
            // 5. cmovge ~ (SF ^ OF)
            // 6. cmovg ~ ((SF ^ OF) | ZF) 

            begin
                select_lines[0] = 1'd0;
                select_lines[1] = 1'd0; // Select Addition

                if(ifun == 4'd0) //Unconditional move
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end

                else if (ifun == 4'd1 && ((SF ^ OF) | ZF)) //cmovle
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
                else if (ifun == 4'd2 && (SF ^ OF)) //cmovl
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
                else if (ifun == 4'd3 && ZF) //cmove
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
                else if (ifun == 4'd4 && !(ZF)) //cmovne
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
                else if (ifun == 4'd5 && !(SF ^ OF)) //cmovge
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
                else if (ifun == 4'd6 && !((SF ^ OF) || ZF)) //cmovg
                begin
                    A_input = valA;
                    B_input = 64'd0;
                    valE = ALU_Output;
                    cnd = 1'b1;
                end
            end

        4'd3: // irmovq
            begin
                select_lines[0] = 1'd0;
                select_lines[1] = 1'd0; // Select Addition
                A_input = valC;
                B_input = 64'd0;
                valE = ALU_Output; //valE = valC + 0
            end

        4'd4, 4'd5: // rmmovq, mrmovq
            begin
                select_lines[0] = 1'd0;
                select_lines[1] = 1'd0; // Select Addition
                A_input = valC;
                B_input = valB;
                valE = ALU_Output; // valE = valB + valC
            end

        4'd6: // OPq
            begin

                select_lines[0] = ifun[0];
                select_lines[1] = ifun[1];
                
                A_input = valB;
                B_input = valA;
                valE = ALU_Output; // VAlE = valB (op) valA

                ZF = (ALU_Output == 64'b0); 
                SF = (ALU_Output < 64'b0); 
                OF = (A_input < 64'b0 == B_input < 64'b0) && (ALU_Output < 64'b0 != A_input < 64'b0);

            end

        4'd7: // jXX
            begin

            //Since this is Y-86, we only have [zf, sf, of] (in this order) to work with.
            //That leaves us with the six jump instructions: 

            // 1. jle (SF ^ OF) | ZF
            // 2. jl SF ^ OF
            // 3. je ZF
            // 4. jne ~ZF
            // 5. jge ~ (SF ^ OF)
            // 6. jg ~ ((SF ^ OF) | ZF) 

                if (ifun == 4'd0) // jmp (unconditional)
                    cnd = 1'b1;
                else if (ifun == 4'd1 && (ZF || (SF ^ OF))) // jle
                    cnd = 1'b1;
                else if (ifun == 4'd2 && (SF ^ OF)) // jl
                    cnd = 1'b1;
                else if (ifun == 4'd3 && ZF) // je
                    cnd = 1'b1;
                else if (ifun == 4'd4 && !(ZF)) // jne
                    cnd = 1'b1;
                else if (ifun == 4'd5 && !(SF ^ OF)) // jge
                    cnd = 1'b1;
                else if (ifun == 4'd6 && !((SF ^ OF) || ZF)) // jg
                    cnd = 1'b1;
            end
    
        4'd11, 4'd9: // popq or ret
            begin
                select_lines[0] = 1'b0;
                select_lines[1] = 1'b0;
                A_input = valB;
                B_input = 64'd8;
                valE = ALU_Output; //valE = valB + 8
            end

        4'd10, 4'd8: // pushq or call
            begin
                select_lines[0] = 1'b1;
                select_lines[1] = 1'b0; //Choosing subtraction
                A_input = valB;
                B_input = 64'd8;
                valE = ALU_Output; //valE = valB - 8
            end
    
        endcase 
    end

endmodule