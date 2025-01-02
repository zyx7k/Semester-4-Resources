module memory_registers(e_stat, clk, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM, 
    M_stat, M_icode, M_valE, M_valA, M_cnd, M_dstE, M_dstM, M_bubble
);

input [2:0] e_stat;
input clk, e_cnd, M_bubble;
input [3:0] e_icode, e_dstE, e_dstM;
input [63:0] e_valA, e_valE;

output reg[2:0] M_stat;
output reg M_cnd;
output reg[3:0] M_icode, M_dstE, M_dstM;
output reg[63:0] M_valA, M_valE;

always @(posedge clk)
begin
    if(!M_bubble)
    begin
        M_stat = e_stat; 
        M_icode = e_icode; 
        M_valA = e_valA;
        M_valE = e_valE; 
        M_cnd = e_cnd; 
        M_dstE = e_dstE;
        M_dstM = e_dstM;
    end
    else
    begin
        M_stat = 1; //AOK Normal Operation  
        M_icode = 1; // nop
        M_valA = 0;
        M_valE = 0; 
        M_cnd = 0; 
        M_dstE = 0;
        M_dstM = 0;
    end
end

endmodule