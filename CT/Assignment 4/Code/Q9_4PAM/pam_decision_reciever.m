function output = pam_decision_reciever(input)

real_values = real(input);

% Now, map the received values to the output
output = zeros(size(real_values));

for i = 1:length(real_values)
    if real_values(i) < -5.5 %boundaries(1)
        output(i) = -3;
    elseif real_values(i) < 0 %boundaries(2)
        output(i) = -1;
    elseif real_values(i) < 5.5 %boundaries(3)
        output(i) = 1;
    else
        output(i) = 3;
    end
end

end