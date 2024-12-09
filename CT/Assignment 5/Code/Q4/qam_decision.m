function output = qam_decision(input)

% Now, map the received values to the output
output = zeros(size(input));
points = [-3-3j, -3-1j, -3+1j, -3+3j, -1-3j, -1-1j, -1+1j, -1+3j, 1-3j, 1-1j, 1+1j, 1+3j, 3-3j, 3-1j, 3+1j, 3+3j];

for i = 1:length(input)
    
    norms = abs(input(i) - points);
    [~, index] = min(norms);
    output(i) = points(index);

end

end