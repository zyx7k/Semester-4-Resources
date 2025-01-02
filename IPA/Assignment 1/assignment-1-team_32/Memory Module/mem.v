module mem (
    input write,
    input read,
    input clk,
    input [63:0] address_in,
    input [63:0] data_in,
    output reg error,
    output reg[63:0] data_out

    );

    reg[63:0] memory_data[255:0]; //considering 256 words to work with

    initial begin
        error <= 1'b0;
    end

    always @(posedge clk)
        begin
            if(address_in < 0 || address_in > 255 || (write==1 && read==1))
                begin
                    error <= 1'b1; //Address provided is outside the specified range
                end

            else if(write == 1 && read == 0)
                begin
                    error <= 1'b0; //Valid operation, so set the error back to 0
                    memory_data[address_in] <= data_in;
                end
            else if(write ==0 && read == 1)
                begin
                    error = 1'b0; //Valid operation, so set the error back to 0
                    data_out <= memory_data[address_in];
                end
            else // Condition arises when both read and write are 0
                begin
                    error <= 1'b0; //No operation, but no error.
                    $display("No operation was performed\n");
                end
        end

endmodule