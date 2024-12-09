function output = sixteenqammap(input)
    N = length(input)/4;
    output = complex(0, N);
    for k = 1:N
        array1 = [input(4*k-3), input(4*k-2)];
        array2 = [input(4*k-1), input(4*k)];
        bc = fourpammap(array1);
        bs = fourpammap(array2);
        output(k) = bc + 1j*bs;
    end
end