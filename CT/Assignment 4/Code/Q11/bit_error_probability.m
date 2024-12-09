% Range of Eb/N0 in dB
EbN0_dB = 0:0.00001:10;

% Eb/N0 from dB to linear scale
EbN0_linear = 10.^(EbN0_dB/10);

% Calculate the ideal bit error probability for BPSK
bit_error_prob = 0.5 * erfc((6-3*sqrt(2))*EbN0_linear/(2*sqrt(2)));

% Plot the results on a logarithmic scale
semilogy(EbN0_dB, bit_error_prob);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability');
title('Bit Error Probability for 4PAM');
grid on;

%_______________________________________________%

% bit_error_prob = 0.5 * erfc(sqrt(0.4*EbN0_linear));

ber1 = 0.01;

x1 = 10*log10(2*sqrt(2)*erfcinv(2*ber1)/(6-3*sqrt(2)));

x1_linear = 10^(x1/10);

disp(['Eb/N0 value in Linear for 10^-2 Bit Error Probability: ', num2str(x1_linear)]);
disp(['Eb/No value in dB  for 10^-2 Bit Error Probability: ', num2str(x1)]);
