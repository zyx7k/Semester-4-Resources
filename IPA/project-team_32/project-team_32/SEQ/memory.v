module memory(
    icode, clk, valA, valE, valM, valP, dmem_error
);

input clk;
input [3:0] icode;
input [63:0] valA, valE, valP;

output reg [63:0] valM;
output reg dmem_error;

//Creating the RAM
reg[63:0] mem[0:255]; //considering 256 words to work with
initial valM = 64'b0;

always @(*)
    begin
    
        dmem_error = 1'b0;

            case(icode)

            //PC Update not required
                // -->nop -->halt

            //cmovXX
                //Do nothing

            //irmovq
                //Do nothing

            //rmmovq
            4'b0100: begin 

                if((valE<0)||(valE>255)) begin dmem_error = 1'b1; end

                else begin mem[valE] = valA; end
                
                end

            //mrmovq
            4'b0101: begin

                if((valE<0)||(valE>255)) begin dmem_error = 1'b1; end

                else begin valM = mem[valE]; end
                
                end

            //OPq
                //Do nothing

            //jXX
                //Do nothing

            //call
            4'b1000: begin

                if((valE<0)||(valE>255)) begin dmem_error = 1'b1; end

                else begin mem[valE] = valP; end
                
                end

            //ret
            4'b1001: begin

                if((valA<0)||(valA>255)) begin dmem_error = 1'b1; end

                else begin valM = mem[valA]; end
                
                end

            //pushq
            4'b1010: begin
                
                if((valE<0)||(valE>255)) begin dmem_error = 1'b1; end

                else begin mem[valE] = valA; end
            
            end

            //popq
            4'b1011: begin
                
                if((valA<0)||(valA>255)) begin dmem_error = 1'b1; end

                else begin valM = mem[valA]; end
                
                end

            endcase
    end
endmodule