module decode(D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, e_dstE, e_valE, M_dstE, M_valE, M_dstM, m_valM, W_dstM, W_valM, W_dstE, W_valE, clk, 
d_stat, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB
);

input [2:0] D_stat;
input [3:0] D_icode, D_ifun, D_rA, D_rB;
input [63:0] D_valC, D_valP;
input clk;

input [3:0] e_dstE, M_dstE, M_dstM, W_dstM, W_dstE;
input [63:0] e_valE, M_valE, m_valM, W_valM, W_valE;

output reg[2:0] d_stat;
output reg[3:0] d_icode, d_ifun, d_srcA, d_srcB, d_dstE, d_dstM;
output reg[63:0] d_valC, d_valA, d_valB;

reg [63:0] memReg [0:15];


initial 
begin
    memReg[0] = 64'd1;    
    memReg[1] = 64'd2;    
    memReg[2] = 64'd3;    
    memReg[3] = 64'd4;    
    memReg[4] = 64'd154;    // Rsp
    memReg[5] = 64'd5;    
    memReg[6] = 64'd6;    
    memReg[7] = 64'd7;    
    memReg[8] = 64'd8;    
    memReg[9] = 64'd9;    
    memReg[10] = 64'd10;    
    memReg[11] = 64'd11;    
    memReg[12] = 64'd12;    
    memReg[13] = 64'd13;    
    memReg[14] = 64'd14;    
    memReg[15] = 64'd0; //F register
end

// Params with no change, wires
always @(*)
begin
    d_stat = D_stat;
    d_icode = D_icode;
    d_ifun = D_ifun; 
    d_valC = D_valC;
end

//Update Register file
always @(posedge clk)
begin
    memReg[W_dstM] <= W_valM;
    memReg[W_dstE] <= W_valE;
end

// Setting up Destination Registers
// I Recommend seeing the slides regarding SEQ Implementation
// And then observe the destination regsiters chosen for different
// operations for decode (srcA, srcB), memory (d_dstE) and writeback (d_dest)
// Read the slides thoroughly do get an idea about how we are choosing the
// destination registers for different icodes.
// This has not been mentioned in the book directly, so you have to find your own way out.

always @(*)
begin
        case(d_icode)
       
        //cmovXX
        4'b0010: 
        begin
            d_srcA = D_rA;
            d_srcB = 4'd15;
            d_dstE = D_rB; 
            d_dstM = 4'd15;
        end

        //irmovq
        4'b0011: 
        begin 
            d_srcA = 4'd15;
            d_srcB = 4'd15;
            d_dstE = D_rB; 
            d_dstM = 4'd15; 
        end

        //rmmovq
        4'b0100:
        begin
            d_srcA = D_rA; 
            d_srcB = D_rB;
            d_dstE = 4'd15;
            d_dstM = 4'd15;
        end

        //mrmovq
        4'b0101: 
        begin 
            d_srcA = 4'd15;
            d_srcB = D_rB;
            d_dstE = 4'd15;
            d_dstM = D_rA;
        end

        //OPq
        4'b0110: 
        begin 
            d_srcA = D_rA; 
            d_srcB = D_rB;
            d_dstE = D_rB;
            d_dstM = 4'd15;
        end

        //jXX
        4'b0111:
        begin
            d_srcA = 4'd15;
            d_srcB = 4'd15;
            d_dstE = 4'd15;
            d_dstM = 4'd15;
        end

        //call
        4'b1000: 
        begin 
            d_srcA = 4'd15;
            d_srcB = 4'd4;
            d_dstE = 4'd4;
            d_dstM = 4'd15;
        end 

        //ret
        4'b1001: 
        begin 
            d_srcA = 4'd4;
            d_srcB = 4'd4;
            d_dstE = 4'd4;
            d_dstM = 4'd15;
        end 

        //pushq
        4'b1010: 
        begin 
            d_srcA = D_rA; 
            d_srcB = 4'd4;
            d_dstE = 4'd4;
            d_dstM = 4'd15;
        end 

        //popq
        4'b1011: 
        begin
            d_srcA = 4'd4;
            d_srcB = 4'd4;
            d_dstE = 4'd4;
            d_dstM = D_rA;
        end

        endcase
        
end

// Sel+Fwd A Logic --> Mentioned in book
// The order matters here
always @(*)
begin
    if(D_icode == 4'd7 || D_icode == 4'd8)
    begin d_valA = D_valP; end

    else if(d_srcA == e_dstE)
    begin d_valA = e_valE; end

    else if(d_srcA == M_dstM)
    begin d_valA = m_valM; end

    else if(d_srcA == M_dstE)
    begin d_valA = M_valE; end

    else if(d_srcA == W_dstM)
    begin d_valA = W_valM; end

    else if(d_srcA == W_dstE)
    begin d_valA = W_valE; end

    else
    begin d_valA = memReg[d_srcA]; end
    
end

// Fwd B Logic --> Logic similar to Fwd A
// The order matters here 
always @(*)
begin

    if(d_srcB == e_dstE)
    begin d_valB = e_valE; end

    else if(d_srcB == M_dstM)
    begin d_valB = m_valM; end

    else if(d_srcB == M_dstE)
    begin d_valB = M_valE; end

    else if(d_srcB == W_dstM)
    begin d_valB = W_valM; end

    else if(d_srcB == W_dstE)
    begin d_valB = W_valE; end

    else
    begin d_valB = memReg[d_srcB]; end
    
end

endmodule