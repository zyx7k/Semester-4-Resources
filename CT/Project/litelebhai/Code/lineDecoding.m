function lineDecodedSignal = lineDecoding(demodulatedSignal)
 
    % So we will sample at every 17th sample starting from the 9th sample

    N = length(demodulatedSignal);
    N = (N-16)/17;
    lineDecodedSignal = ones(1, N);

    for k = 0 : N-1
        sampledValue = demodulatedSignal(17*k+9);
        if(sampledValue<0)
            lineDecodedSignal(k+1) = -1;
        end
    end
end