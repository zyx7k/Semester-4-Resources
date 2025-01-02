`include "mem.v"
`timescale 1ns / 1ns

module memory_tb;

    reg write, read;
    reg [63:0] address_in, data_in;

    wire error;
    wire [63:0] data_out;

    mem UUT (
        .write(write), 
        .read(read), 
        .clk(clk), 
        .address_in(address_in), 
        .data_in(data_in), 
        .error(error), 
        .data_out(data_out)
    );

    // Clock generation
    reg clk = 0;
    always #5 clk = ~clk;

    always @(posedge clk) begin

        if(read == 1 && write==1) begin
            $display("Error: Both Read and Write requested simultaneously\n");
        end
        
        else if(error==1) begin
            $display("Error: Invalid Address requested\n");
        end

        else if(error==0 && read ==1 && write==0) begin
            $display("The value being read at address %d is %d\n", address_in, data_out);
        end

        else if(error==0 && read ==0 && write==1) begin 
            $display("The value being written at address %d is %d\n", address_in, data_in);
        end
    end


    initial begin
        $dumpfile("gtkwave.vcd");
        $dumpvars(0, UUT);

        // Initialize memory data

        write = 1'b0; // Initializing Write to 0
        read = 1'b0; // Initializing Read to 0
        data_in = 64'b0; 

        #10;
        write = 1'b1;
        data_in = 64'd12;
        address_in = 64'd217;

        #10;
        write = 1'b0;
        data_in = 0;

        #10;
        read = 1'b1;

        #20;
        read = 1'b0;
        
        #10;
        read = 1'b1;
        write = 1'b1;

        #10;
        read = 1'b0;
        
        #5;
        data_in = 64'd19;
        address_in = 64'd256;

        #10;
        $finish;
    end

endmodule
