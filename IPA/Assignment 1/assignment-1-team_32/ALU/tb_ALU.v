module alu_tb;

    reg [63:0] A, B;
    reg S0, S1;
    wire [63:0] Output;
    wire Overflow;

    alu UUT (
        .A(A),
        .B(B),
        .S0(S0),
        .S1(S1),
        .Output(Output),
        .Overflow(Overflow)
    );

    initial $monitor("A = %b, \nB = %b, \nS0 = %b, \nS1 = %b, \nOutput=%b, \nOverflow=%b\n",A,B,S0,S1,Output,Overflow);

    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, alu_tb);
        
        // Initialize inputs
        A = (2**63-1);
        B = 1;
        S1 = 0;
        S0 = 0;
        #10

        A = -(2**63);
        B = -1;
        S1 = 0;
        S0 = 0;
        #10
        
        A = 8;
        B = 7;
        S1 = 0;
        S0 = 0;
        #10

        A = -(2**63);
        B = 1;
        S1 = 0;
        S0 = 1;
        #10

        A = (2**63-1);
        B = -1;
        S1 = 0;
        S0 = 1;
        #10

        A = 7;
        B = 8;
        S1 = 0;
        S0 = 1;
        #10

        A = 20;
        B = 30;
        S1 = 1;
        S0 = 0;
        #10

        A = 50;
        B = 55;
        S1 = 1;
        S0 = 1;
        #10
    
        $finish;
    end

endmodule
