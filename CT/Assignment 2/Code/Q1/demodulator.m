function output = demodulator(sig1, sig2, fs)
    output = sig1.*sig2;
    cutoff = 10^6;
    output = lowpass(output, cutoff, fs);
end