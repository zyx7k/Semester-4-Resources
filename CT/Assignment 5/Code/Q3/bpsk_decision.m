function output = bpsk_decision(input)

output = zeros(1,length(input));

for k = 1 : length(input)
    if(input(k)>0)
        output(k) = 1;
    else
        output(k) = 0;
    end
end

end