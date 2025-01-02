# Assignment 1   

*Note: This is a group assignment.* 

**Deadline:** 25 Jan 2024 11:59 pm 

### Build An ALU

You are expected to build an ALU unit with following functionality: 

* ADD – 64 bits   

* SUB – 64 bits  

* AND – 64 bits 

* XOR – 64 bits 

You are not allowed to use +, -, &, ^ directly on the 64-bit inputs for 64-bit operations. We expect you to write each of the above modules from scratch. 

All input and output should be signed and use 2’s complement for the subtraction. 

Write a final wrapper ALU unit from where you will call the modules mentioned above based on the control input. The ALU unit takes as input the control signal, and two 64-bit inputs, and returns the 64-bit output corresponding to the control signal chosen. An example with 64-bit inputs x and y: 

    Control 0 - ADD x and y 

    Control 1 – Subtract y from x 

    Control 2 – AND x and y 

    Control 3 – XOR x and y 

### Build memory module
You are expected to build a memory module with following functionality:

Check the validity of the memory address (64-bit) and based on that:

* Read from the memory
  
* Write to the memory



**Files to be submitted:**

* Verilog module for each operation 
* Verilog testbench for each operation – try to test for all or a considerable number of input combinations  
* Verilog module for the wrapper ALU unit 
* Verilog testbench for the wrapper ALU unit .
* Verilog module for memory unit.
* Verilog test bench to verify the functionality of memory unit.
* A report summarizing your approach and results. Clearly mention the control inputs to the ALU and their corresponding functionality, and the tests you performed in the testbenches. Results should contain the screenshots of the waveforms for each operation on 64-bit inputs. Follow the same for memory unit.


Do not indulge in any malpractices or plagiarism. Any such malpractice will have serious consequences. 

*Happy coding!* 
