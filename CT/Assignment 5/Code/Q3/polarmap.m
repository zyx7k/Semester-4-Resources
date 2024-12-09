function output = polarmap(input)
    N = length(input);
    output = ones(1,N);
    for k = 1:N
        if(input(k)==0)
            output(k) = -1;
        end
    end
end