module execute_registers(d_stat, clk, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, 
    E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, E_bubble
);

input [2:0] d_stat;
input clk, E_bubble;
input [3:0] d_icode, d_ifun, d_dstE, d_dstM, d_srcA, d_srcB;
input [63:0] d_valC, d_valA, d_valB;

output reg[2:0] E_stat;
output reg[3:0] E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB;
output reg[63:0] E_valC, E_valA, E_valB;

always @(posedge clk)
begin
    if(!E_bubble)
    begin
        E_stat <= d_stat; 
        E_icode <= d_icode; 
        E_ifun <= d_ifun; 
        E_valC <= d_valC;
        E_valA <= d_valA; 
        E_valB <= d_valB;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB; 
    end
    else
    begin   
        E_stat <= 1; //AOK Normal Operation
        E_icode <= 1; // nop
        E_ifun <= 0;
        E_valC <= 0;
        E_valA <= 0; 
        E_valB <= 0;
        E_dstE <= 0;
        E_dstM <= 0;
        E_srcA <= 0;
        E_srcB <= 0; 
    end
end

endmodule