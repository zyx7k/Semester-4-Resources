function output = eightpskmap(input)
   N = length(input)/3;
   output = ones(1,N);
   for k =1:N
        firstBit = input(3*k-2);
        secondBit = input(3*k-1);
        thirdBit = input(3*k);

        if(firstBit==0 && secondBit==0 && thirdBit==1)
            number = 1; 
        elseif(firstBit==0 && secondBit==1 && thirdBit==1)
            number = 2; 
        elseif(firstBit==0 && secondBit==1 && thirdBit==0)
            number = 3; 
        elseif(firstBit==1 && secondBit==1 && thirdBit==0)
            number = 4; 
        elseif(firstBit==1 && secondBit==1 && thirdBit==1)
            number = 5; 
        elseif(firstBit==1 && secondBit==0 && thirdBit==1)
            number = 6;
        elseif(firstBit==1 && secondBit==0 && thirdBit==0)
            number = 7; 
        else
            number = 0; 
        end

        angle = 2*pi*number/8;
        output(k) = cos(angle)+1j*sin(angle);
   end
end