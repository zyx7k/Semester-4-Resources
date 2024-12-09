function output = pam_decision_transmitter(input)

k = length(input);
output = zeros(1, k);

for i = 1 : k
    if input(i) >= 2
        output(i) = 3;
    elseif input(i) >= 0
        output(i) = 1;

    elseif input(i) >= -2
        output(i) = -1;
    else
        output(i) = -3;
    end
end

end