module control(W_stat, M_icode, m_stat, e_cnd, E_dstM, E_icode, d_srcA, d_srcB, D_icode, 
        W_stall, M_bubble, E_bubble, D_bubble, D_stall, F_stall    
        );

input e_cnd;
input [2:0] W_stat, m_stat;
input [3:0] M_icode, E_dstM, E_icode, d_srcA, d_srcB, D_icode; 

output reg W_stall, M_bubble, E_bubble, D_bubble, D_stall, F_stall;

// Hazards: 
wire processing_ret;
wire lu_hazard;
wire mispredicted_branch;
wire execption;

// Using assign statement because we are using wires --> refer textbook for logic
assign processing_ret = ((M_icode == 4'd9) || (E_icode == 4'd9) || (D_icode == 4'd9)) ? 1 : 0;
assign lu_hazard = (((E_icode == 4'd5) || (E_icode == 4'd11)) && ((E_dstM == d_srcA) || (E_dstM == d_srcB))) ? 1 : 0;
assign mispredicted_branch = ((E_icode == 4'd7) && !e_cnd) ? 1 : 0;
assign execption = ((m_stat == 3'd2) || (m_stat == 3'd3) || (m_stat == 3'd4) || (W_stat == 3'd2) || (W_stat == 3'd3) || (W_stat == 3'd4)) ? 1 : 0;

// Assigning stall and bubble values --> Everything can be find in text and its solutions

// 1.  Pipeline register F must be stalled for either a load/use hazard or a ret instruction:
always @(*)
begin F_stall = (processing_ret == 1 || lu_hazard == 1); end

// 2. Pipeline register D must be set to bubble for a mispredicted branch or a ret instruction
always @(*)
begin D_stall = (lu_hazard == 1); end

always @(*)
begin D_bubble = ((mispredicted_branch == 1 || processing_ret == 1) && !((lu_hazard == 1) && (processing_ret == 1))); end

// 3. pipeline register E must be set to bubble for a load/use hazard or for a mispredicted branch
always @(*)
begin E_bubble = (lu_hazard == 1 || mispredicted_branch ==1); end

// 4. Injecting a bubble into the memory stage on the next cycle involves checking for
// an exception in either the memory or the write-back stage during the current cycle

always @(*)
begin M_bubble = (execption == 1); end

// 5.For stalling the write-back stage, we check only the status of the instruction
// in this stage.

always @(*)
begin W_stall = ((W_stat == 3'd2) || (W_stat == 3'd3) || (W_stat == 3'd4)); end

endmodule

