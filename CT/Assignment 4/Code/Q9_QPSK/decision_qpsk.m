function output = decision_qpsk(input)
    output = zeros(1,length(input));

    for k = 1 : length(input)
        real_part = real(input(k));
        imag_part = imag(input(k));
        if(real_part>0)
            real_part = 1;
        else
            real_part = -1;
        end
        if(imag_part>0)
            imag_part = 1;
        else
            imag_part = -1;
        end
            
        output(k) = real_part + (1j)*imag_part;
        
     end
end