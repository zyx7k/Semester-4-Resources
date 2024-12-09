function output = decision_qam_transmitter(input)
    k = length(input);
    output = zeros(1, k);

    for i = 1 : k
        real_part = real(input(i));
        imag_part = imag(input(i));

        if real_part >= 2
            real_part = 3;
        elseif real_part >= 0
            real_part = 1;
        elseif real_part >= -2
            real_part = -1;
        else
            real_part = -3;
        end

        if imag_part >= 2
            imag_part = 3;
        elseif imag_part >= 0
            imag_part = 1;
        elseif imag_part >= -2
            imag_part = -1;
        else
            imag_part = -3;
        end

        output(i) = real_part + (1j)*imag_part;
    end
end