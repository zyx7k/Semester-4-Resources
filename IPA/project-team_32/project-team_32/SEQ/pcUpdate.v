module pcUpdate (
    icode, cnd, clk, valC, valM, valP, updatedPC
);

input clk, cnd;
input [3:0] icode;
input [63:0] valC, valM, valP;

output reg [63:0] updatedPC;

initial updatedPC = 64'd2;

always @(*)
    begin
        case(icode)

        //PC Update not required
            // -->nop -->halt

        //cmovXX
        4'b0010: begin updatedPC = valP; end

        //irmovq
        4'b0011: begin updatedPC = valP; end

        //rmmovq
        4'b0100: begin updatedPC = valP; end

        //mrmovq
        4'b0101: begin updatedPC = valP; end

        //OPq
        4'b0110: begin updatedPC = valP; end

        //jXX
        4'b0111: begin 
                        if(cnd == 1'b1)
                        begin updatedPC = valC; end

                        else
                        begin updatedPC = valP; end
        end 

        //call
        4'b1000: begin updatedPC = valC; end

        //ret
        4'b1001: begin updatedPC = valM; end

        //pushq
        4'b1010: begin updatedPC = valP; end

        //popq
        4'b1011: begin updatedPC = valP; end

        endcase
    end

endmodule