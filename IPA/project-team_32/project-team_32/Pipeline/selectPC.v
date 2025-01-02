module selectPC (       
    M_icode, M_cnd, M_valA, W_icode, W_valM, F_predPC, f_pc
);

input [3:0] M_icode, W_icode;
input M_cnd;
input [63:0] M_valA, W_valM, F_predPC;

output reg [63:0] f_pc;

always @(*)
begin

    f_pc = F_predPC; //Default Value

    if(M_icode == 4'b0111 && !M_cnd)
    begin f_pc = M_valA; end // Mispredicted branch. Fetch at incremented PC

    else if(W_icode == 4'b1001)
    begin f_pc = W_valM; end //C ompletion of RET instruction

end 
endmodule