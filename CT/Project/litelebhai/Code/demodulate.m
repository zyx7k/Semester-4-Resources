function out = demodulate(in)
    fc = 10^6;
    fs = 10*fc;
    t = 0:1/fs:(length(in)/fs);
    for count = 1:length(in)
        out{1}(count) = in(count).*cos(2*pi*fc*t(count)+(pi/4));
        out{2}(count) = in(count).*sin(2*pi*fc*t(count)+(pi/4));
    end

    out{1} = lowpass(out{1}, 1000,fs);
    out{2} = lowpass(out{2}, 1000,fs);
end