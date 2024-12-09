clear;

n = 100000;
n_bits = randbit(n);
pam_n_bits = sixteenpammap(n_bits);

snrValues = 0 : 1 : 19;
berValues = zeros(1,length(snrValues));

figure(1);
for k = 1 : length(snrValues)
    EbN0_dB = snrValues(k);
    EbN0_linear = 10^(EbN0_dB/10);
    Eb = 85/4;
    N0 = Eb/EbN0_linear;
    sigma = sqrt(N0/2);
    real_part = sigma * randn(1, n/4);
    imag_part = sigma * randn(1, n/4);
    noise = complex(real_part, imag_part);
    
    signal_transmited = pam_n_bits + noise;

    signal_recieved = pam_decision(signal_transmited);
    difference = 0;
    for i = 1 : n/4
        if(signal_recieved(i)~=pam_n_bits(i))
            difference = difference + 1;
        end
    end
    berValues(k) = 4*difference/n;
    disp(berValues(k));
    if(k>=18)
    subplot(3, 1, k-17); % Arrange plots in a 3x1 grid
    scatter(real(signal_transmited), imag(signal_transmited));
    xlabel('Real Amplitude');
    ylabel('Imaginary Amplitude');
    title(sprintf('SNR: %d dB, BER: %.3f', EbN0_dB, berValues(k))); % Add title
    end
end

% Range of Eb/N0 in dB
EbN0_dB = 0:1:19;

% Eb/N0 from dB to linear scale
EbN0_linear = 10.^(EbN0_dB/10);

% Calculate the ideal bit error probability for 16PAM
bit_error_prob = 0.5 * erfc(sqrt(0.4*EbN0_linear));

% Plot the results on a logarithmic scale
figure(2);
semilogy(EbN0_dB, berValues, 'b--', EbN0_dB, bit_error_prob, 'r--');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability');
title('Bit Error Probability for 16PAM')
legend('Simulation', 'Analytical');
grid on;

