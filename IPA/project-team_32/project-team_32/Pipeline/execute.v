`include "ALU.v"

module execute(
    clk, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_stat, m_stat,
    e_stat, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM, ZF, SF, OF
);

input clk;
input [2:0] E_stat, W_stat, m_stat;
input [3:0] E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB;
input [63:0] E_valC, E_valA, E_valB;

output reg e_cnd, ZF, SF, OF;
output reg [2:0] e_stat;
output reg [3:0] e_icode, e_dstE, e_dstM;
output reg [63:0] e_valE, e_valA;

// Params with no change, wires
always @(*)
begin
    e_stat = E_stat;
    e_icode = E_icode;
    e_valA = E_valA; 
    e_dstM = E_dstM; 
end

reg signed [63:0] A_input;
reg signed [63:0] B_input;
reg [1:0] select_lines;

wire signed [63:0] ALU_Output;
wire overflow;

alu alu1(.A(A_input), .B(B_input), .S0(select_lines[0]), .S1(select_lines[1]), .Output(ALU_Output), .Overflow(overflow));

always @(*)
begin
    // Perform operations based on icode
    case (e_icode)

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

                if(E_ifun == 4'd0) //Unconditional move
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end

                else if (E_ifun == 4'd1 && ((SF ^ OF) | ZF)) //cmovle
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
                else if (E_ifun == 4'd2 && (SF ^ OF)) //cmovl
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
                else if (E_ifun == 4'd3 && ZF) //cmove
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
                else if (E_ifun == 4'd4 && !(ZF)) //cmovne
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
                else if (E_ifun == 4'd5 && !(SF ^ OF)) //cmovge
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
                else if (E_ifun == 4'd6 && !((SF ^ OF) || ZF)) //cmovg
                begin
                    A_input = E_valA;
                    B_input = 64'd0;
                    e_valE = ALU_Output;
                    e_cnd = 1'b1;
                end
            end

        4'd3: // irmovq
            begin
                select_lines[0] = 1'd0;
                select_lines[1] = 1'd0; // Select Addition
                A_input = E_valC;
                B_input = 64'd0;
                e_valE = ALU_Output; //valE = valC + 0
            end

        4'd4, 4'd5: // rmmovq, mrmovq
            begin
                select_lines[0] = 1'd0;
                select_lines[1] = 1'd0; // Select Addition
                A_input = E_valC;
                B_input = E_valB;
                e_valE = ALU_Output; // valE = valB + valC
            end

        4'd6: // OPq
            begin

                select_lines[0] = E_ifun[0];
                select_lines[1] = E_ifun[1];
                
                A_input = E_valB;
                B_input = E_valA;
                e_valE = ALU_Output; // VAlE = valB (op) valA

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

                e_cnd = 1'b0;

                if (E_ifun == 4'd0) // jmp (unconditional)
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd1 && (ZF || (SF ^ OF))) // jle
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd2 && (SF ^ OF)) // jl
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd3 && ZF) // je
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd4 && !(ZF)) // jne
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd5 && !(SF ^ OF)) // jge
                    e_cnd = 1'b1;
                else if (E_ifun == 4'd6 && !((SF ^ OF) || ZF)) // jg
                    e_cnd = 1'b1;
            end
    
        4'd11, 4'd9: // popq or ret
            begin
                select_lines[0] = 1'b0;
                select_lines[1] = 1'b0;
                A_input = E_valB;
                B_input = 64'd8;
                e_valE = ALU_Output; //valE = valB + 8
            end

        4'd10, 4'd8: // pushq or call
            begin
                select_lines[0] = 1'b1;
                select_lines[1] = 1'b0; //Choosing subtraction
                A_input = E_valB;
                B_input = 64'd8;
                e_valE = ALU_Output; //valE = valB - 8
            end
    
        endcase 
end

always @(posedge clk)
begin
    if((e_icode == 4'b0110) && (m_stat == 1) && (W_stat == 1)) //remember stat = 1 indicates normal operation
    ZF = (ALU_Output == 64'b0); 
    SF = (ALU_Output < 64'b0); 
    OF = (A_input < 64'b0 == B_input < 64'b0) && (ALU_Output < 64'b0 != A_input < 64'b0);
end

// Setting up destination register for execute
always @(*)
begin
    if((e_icode == 4'b0010) && (e_cnd == 1'b0))
    begin e_dstE = 4'd15; end // rB < -- 0xF, refer slides

    else
    begin e_dstE = E_dstE; end
end

endmodule