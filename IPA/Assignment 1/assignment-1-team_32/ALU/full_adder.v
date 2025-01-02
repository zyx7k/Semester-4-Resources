module full_adder(input A,B,C0, output Sum,Carry);

    wire a1,a2,a3;
    xor gate1(a1, A, B);
    and gate2(a2, A, B);
    and  gate3(a3, a1, C0);
    xor gate4(Sum, a1, C0);
    or gate5(Carry, a2, a3);

endmodule