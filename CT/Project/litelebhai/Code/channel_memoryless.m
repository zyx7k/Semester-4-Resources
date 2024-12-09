function out = channel_memoryless(in, sigma)
    out = zeros(1,length(in));
    for k = 1:length(in)
        out(k) = in(k) + sigma*randn;
    end
end