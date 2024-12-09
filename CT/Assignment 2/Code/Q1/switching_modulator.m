function output = switching_modulator(sig1, sig2, fs)
       output = sig1.*sig2;
       fc = 10^6;
       fm = 10^4;
       output = bandpass(output, [fc-fm, fc+fm], fs);
end