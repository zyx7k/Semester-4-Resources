function output = pam_decision(input)

% Now, map the received values to the output
output = zeros(size(input));

for i = 1:length(input)
    if input(i) < -14
        output(i) = -15;
    elseif input(i) < -12
        output(i) = -13;
    elseif input(i) < -10
        output(i) = -11;
    elseif input(i) < -8 
        output(i) = -9;
    elseif input(i) < -6 
        output(i) = -7;
    elseif input(i) < -4 
        output(i) = -5;
    elseif input(i) < -2 
        output(i) = -3;
    elseif input(i) < 0 
        output(i) = -1;
    elseif input(i) < 2 
        output(i) = 1;
    elseif input(i) < 4 
        output(i) = 3;
    elseif input(i) < 6 
        output(i) = 5;
    elseif input(i) < 8
        output(i) = 7;
    elseif input(i) < 10 
        output(i) = 9;
    elseif input(i) < 12
        output(i) = 11;
    elseif input(i) < 14
        output(i) = 13;
    else
        output(i) = 15;
    end
end

end