module full_adder_tb;

    // Inputs
    reg A, B, C0;
    
    // Outputs
    wire Sum, Carry;
    
    // Instantiate the full_adder module
    full_adder uut (
        .A(A),
        .B(B),
        .C0(C0),
        .Sum(Sum),
        .Carry(Carry)
    );


    // Test cases
    initial begin
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        $display("Full Adder");

        // Test case 1
        A = 0;
        B = 0;
        C0 = 0;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);

        // Test case 2
        A = 0;
        B = 0;
        C0 = 1;
        #10;  
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);

        // Test case 3
        A = 0;
        B = 1;
        C0 = 0;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);

        // Test case 4
        A = 0;
        B = 1;
        C0 = 1;
        #10;  
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);

        // Test case 5
        A = 1;
        B = 0;
        C0 = 0;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);

        // Test case 6
        A = 1;
        B = 0;
        C0 = 1;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);
        
        // Test case 7
        A = 1;
        B = 1;
        C0 = 0;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);
        
        // Test case 8
        A = 1;
        B = 1;
        C0 = 1;
        #10;
        $display("A=%b, B=%b, C0=%b, Sum=%b, Carry=%b", A, B, C0, Sum, Carry);


        // End simulation
        $finish;
    end

endmodule
