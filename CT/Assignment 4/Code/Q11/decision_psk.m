function output = decision_psk(input)
    output = zeros(1, length(input));
    for k = 1 : length(input)

        theta = angle(input(k));

        if(theta > (-1*pi/8) && theta <= (pi/8))
            number = 0;
        elseif(theta > (pi/8) && theta <= (3*pi/8))
            number = 1;
        elseif(theta > (3*pi/8) && theta <= (5*pi/8))
            number = 2;
        elseif(theta > (5*pi/8) && theta <= (7*pi/8))
            number = 3;
        elseif(theta > (-3*pi/8) && theta <= (-1*pi/8))
            number = 7;
        elseif(theta > (-5*pi/8) && theta <= (-3*pi/8))
            number = 6;
        elseif(theta > (-7*pi/8) && theta <= (-5*pi/8))
            number = 5;
        else
            number = 4;
        end

        phase = 2*pi*number/8;
        output(k) = cos(phase)+(1j)*sin(phase);
    end
end