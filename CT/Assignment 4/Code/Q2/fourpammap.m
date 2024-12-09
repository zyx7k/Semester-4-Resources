function output = fourpammap(input)
    N = length(input)/2;
    output = ones(1,N);
    for k = 1:N
        bit1 = input(2*k-1);
        bit2 = input(2*k);
        if(bit1==0 && bit2==0)
            output(k) = -3;
        elseif(bit1==1 && bit2==0)
            output(k) = 3;
        elseif(bit1==1 && bit2==1)
            output(k) = 1;    
        else
            output(k) = -1;
        end
    end
end