module writeback_register(m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, clk,
    W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, W_stall);

input [2:0] m_stat;
input [3:0] m_icode, m_dstE, m_dstM;
input [63:0] m_valE, m_valM;
input clk, W_stall;

output reg [2:0] W_stat;
output reg [3:0] W_icode, W_dstE, W_dstM;
output reg [63:0] W_valE, W_valM; 

always @(posedge clk)
begin
    if(!W_stall)
    begin
    
        W_stat <= m_stat; 
        W_icode <= m_icode;
        W_dstE <= m_dstE; 
        W_dstM <= m_dstM;
        W_valE <= m_valE;
        W_valM <= m_valM;
        
    end

end

endmodule