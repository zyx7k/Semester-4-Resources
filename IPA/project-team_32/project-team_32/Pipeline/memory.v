module memory(
    input clk,

    // Inputs
    input [3:0] M_icode, 
    input [2:0] M_stat, 
    input [63:0] M_valA, 
    input [63:0] M_valE, 
    input [3:0] M_dstM,
    input [3:0] M_dstE, 

    // Outputs
    output reg[3:0] m_icode,
    output reg[2:0] m_stat, 
    output reg[63:0] m_valE, 
    output reg[63:0] m_valM, 
    output reg[3:0] m_dstM,
    output reg[3:0] m_dstE 
    
);

// Params with no change, wires
always @(*) 
    begin
        m_icode = M_icode;
        m_valE = M_valE;
        m_dstE = M_dstE;
        m_dstM = M_dstM;
    end

// Initiating data memory
reg [63:0] mem[0:255]; //considering 256 words to work with
integer i;

initial 
    begin
        for (i = 255; i >= 0; i = i - 1) 
            begin
                mem[i] <= 0;
            end
    end

// Setting up address memory for dmem_error
reg [63:0]address_memory;
always @(*)
begin
    if((m_icode == 4'd10) || (m_icode == 4'd8) || (m_icode == 4'd4) || (m_icode == 4'd5))
    begin address_memory = M_valE; end

    else if((m_icode == 4'd9) || (m_icode == 4'd11))
    begin address_memory = M_valA; end
end

// Checking memory error
reg dmem_error;
always @(*)
    begin
        dmem_error = (address_memory > 255 || address_memory < 0);
    end

// Writing back to data memory anytime
always @(*) 
    begin
        if(!dmem_error)
        begin
                case (m_icode)
                    4'd10: //pushq
                    begin
                        mem[M_valE] <= M_valA;
                    end

                    4'd8: //call
                    begin
                        mem[M_valE] <= M_valA;
                    end

                    4'd4: //rmmovq
                    begin
                        mem[M_valE] <= M_valA;
                    end
                endcase
        end
    end

//Reading from the memory at any instant 
always @(*) 
    begin
        if(!dmem_error)
            begin
                case (m_icode)

                    4'd9, 4'd11: //popq and ret
                    begin
                        m_valM = mem[M_valA];
                    end

                    4'd5: //mrmovq
                    begin
                        m_valM = mem[M_valE];
                    end
                endcase
            end
    end

// Assigining m_stat
always @(*) 
    begin
        if (dmem_error == 1) 
            begin m_stat = 3; end // ADR, imem_error valid 
        else 
            begin m_stat = M_stat; end
    end

endmodule