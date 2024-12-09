function output = non_linear_modulator(sig1, sig2, fs)
    % sig1 is m(t), sig2 is carrier wave
    sig3 = sig2 + sig1;
    sig4 = sig2 - sig1;
    
    sig5 = nl_block(sig3, 1, 1);
    sig6 = nl_block(sig4, 1, 1);

    z_t = sig5 - sig6;

    % now passing thru the filter %
    fc = 1000000;
    fm = 10000;
    
    output = bandpass(z_t, [fc-fm, fc+fm], fs);
end     