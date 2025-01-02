module fetch_registers(clk, F_predPC, f_predPC, F_stall);

input [63:0] f_predPC;
input clk, F_stall;
output reg [63:0] F_predPC; 

always @(posedge clk)
begin 
    if(!F_stall)
    begin F_predPC = f_predPC; end
end

endmodule