module predictPC (
    f_icode, f_valC, f_valP, f_predPC
);

input [3:0] f_icode;
input [63:0] f_valC, f_valP;

output reg [63:0] f_predPC;

// Logic : The PC prediction logic chooses valC for the fetched instruction when it is
// either a call or a jump, and valP otherwise.
always @(*)
begin
    f_predPC = f_valP; //Default Value

    if(f_icode == 4'b0111 || f_icode == 4'b1000)
    begin f_predPC = f_valC; end

end

endmodule