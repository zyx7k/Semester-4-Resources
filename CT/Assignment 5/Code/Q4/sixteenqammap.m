function output = sixteenqammap(input)
    N = length(input)/4;
    output = ones(1,N);
    for k = 1:N
        bit1 = input(4*k-3);
        bit2 = input(4*k-2);
        bit3 = input(4*k-1);
        bit4 = input(4*k);
        if(bit1==0 && bit2==0 && bit3==0 && bit4==0)
            output(k) = -3+(1j)*(3);
        elseif(bit1==1 && bit2==0 && bit3==0 && bit4==0)
            output(k) = 1+(1j)*(-1);
        elseif(bit1==1 && bit2==0 && bit3==1 && bit4==1)
            output(k) = 1+(1j)*(-3);
        elseif(bit1==0 && bit2==0 && bit3==1 && bit4==1)
            output(k) = -3+(1j)*(1);
        elseif(bit1==1 && bit2==0 && bit3==1 && bit4==0)
            output(k) = 3+(1j)*(-3);
        elseif(bit1==0 && bit2==0 && bit3==1 && bit4==0)
            output(k) = -1+(1j)*(1);
        elseif(bit1==1 && bit2==0 && bit3==0 && bit4==1)
            output(k) = 3+(1j)*(-1);
        elseif(bit1==0 && bit2==0 && bit3==0 && bit4==1)
            output(k) = -1+(1j)*(3);
        elseif(bit1==1 && bit2==1 && bit3==0 && bit4==1)
            output(k) = -1+(1j)*(-1);
        elseif(bit1==0 && bit2==1 && bit3==0 && bit4==1)
            output(k) = 3+(1j)*(3);
        elseif(bit1==1 && bit2==1 && bit3==0 && bit4==0)
            output(k) = -3+(1j)*(-1);
        elseif(bit1==0 && bit2==1 && bit3==0 && bit4==0)
            output(k) = 1+(1j)*(3);
        elseif(bit1==1 && bit2==1 && bit3==1 && bit4==0)
            output(k) = -1+(1j)*(-3);
        elseif(bit1==0 && bit2==1 && bit3==1 && bit4==0)
            output(k) = 3+(1j)*(1);
        elseif(bit1==1 && bit2==1 && bit3==1 && bit4==1)
            output(k) = -3+(1j)*(-3);
        else
            output(k) = 1+(1j)*(1);
        end
    end
end