`include "fetch.v"
`include "decode.v"
`include "execute.v"   
`include "memory.v"
`include "control.v"
// `include "fetch_registers.v"
`include "decode_registers.v"
`include "execute_registers.v"
`include "memory_registers.v"
`include "writeback_registers.v"

module processor();

reg clk;
// Fetch Pipeline Registers
reg [63:0] F_predPC = 0;

// Decode Pipeline wireisters
wire [2:0] D_stat;
wire [3:0] D_icode;
wire [3:0] D_ifun;
wire [3:0] D_rA;
wire [3:0] D_rB;
wire [63:0] D_valC;
wire [63:0] D_valP;

// Execute Pipeline wireisters

wire [2:0] E_stat;
wire [3:0] E_icode;
wire [3:0] E_ifun;
wire [3:0] E_dstE;
wire [3:0] E_dstM;
wire [3:0] E_srcA;
wire [3:0] E_srcB;
wire [63:0] E_valC;
wire [63:0] E_valA;
wire [63:0] E_valB;

wire ZF, SF, OF;

// Memory Pipeline wireisters
wire [3:0] M_icode;
wire [2:0] M_stat;
wire [63:0] M_valA; 
wire [63:0] M_valE; 
wire [3:0] M_dstM;
wire [3:0] M_dstE ;

// Writeback pipeline wireisters
wire [3:0] W_icode;
wire [3:0] W_dstM;
wire [3:0] W_dstE;
wire [63:0] W_valM;
wire [63:0] W_valE;
wire [2:0] W_stat;

// Fetch Outputs
wire [2:0] f_stat;
wire [3:0] f_icode;
wire [3:0] f_ifun;
wire [3:0] f_rA, f_rB;
wire signed[63:0] f_valC, f_valP;
wire signed[63:0] f_predPC;

// Decode Outputs
wire[2:0] d_stat;
wire[3:0] d_icode, d_ifun, d_srcA, d_srcB, d_dstE, d_dstM;
wire  signed[63:0] d_valC, d_valA, d_valB;

// Execute Outputs
wire e_cnd;
wire [2:0] e_stat;
wire [3:0] e_icode, e_dstE, e_dstM;
wire signed[63:0] e_valE, e_valA;

// Memory Outputs
wire [3:0] m_icode;
wire [2:0] m_stat;
wire signed[63:0] m_valE; 
wire signed[63:0] m_valM; 
wire [3:0] m_dstM;
wire [3:0] m_dstE;

// Control Logic Wires
wire W_stall, M_bubble, E_bubble, D_bubble, D_stall, F_stall;

// ******** calling pipeline modules ********* //

// fetch_registers R1(clk, F_predPC, f_predPC, F_stall);
fetch S1(
    F_predPC, M_icode, M_cnd, M_valA, W_icode, W_valM,
    f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, f_predPC, f_stat
);
decode_registers R2(f_stat, clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP,
    D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_bubble, D_stall
);
decode S2(D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, e_dstE, e_valE, M_dstE, M_valE, M_dstM, m_valM, W_dstM, W_valM, W_dstE, W_valE, clk, 
d_stat, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB
);
execute_registers R3(d_stat, clk, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, 
    E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, E_bubble
);
execute S3(
    clk, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_stat, m_stat,
    e_stat, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM, ZF, SF, OF
);
memory_registers R4(e_stat, clk, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM, 
    M_stat, M_icode, M_valE, M_valA, M_cnd, M_dstE, M_dstM, M_bubble
);
memory S4( clk, M_icode, M_stat, M_valA, M_valE, M_dstM, M_dstE, m_icode, m_stat, m_valE, m_valM, m_dstM, m_dstE
);

writeback_register R5(m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, clk,
    W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, W_stall);

control C1(W_stat, M_icode, m_stat, e_cnd, E_dstM, E_icode, d_srcA, d_srcB, D_icode, 
        W_stall, M_bubble, E_bubble, D_bubble, D_stall, F_stall    
        );

//Updating PC Register
always @(posedge clk)
begin 
    if(!F_stall)
    begin F_predPC = f_predPC; end
end


initial 
    begin
    clk = 0;
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    end

initial 
begin
    $dumpfile("processor_tb.vcd");
    $dumpvars(0, processor);  
end

initial 
    begin
    $monitor("PC=%d icode=%d ifun=%d ,valC=%d,valP=%d\n",F_predPC,f_icode,f_ifun,f_valC,f_valP);
    end

endmodule