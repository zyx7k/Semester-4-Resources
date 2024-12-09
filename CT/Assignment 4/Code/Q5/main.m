% Range of Eb/N0 in dB
EbN0_dB = 0:0.00001:30;

% Eb/N0 from dB to linear scale
EbN0_linear = 10.^(EbN0_dB/10);

% Calculate the ideal bit error probability for BPSK
bit_error_prob = 0.5 * erfc(sqrt(EbN0_linear));

% Plot the results on a logarithmic scale
semilogy(EbN0_dB, bit_error_prob);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability');
title('Bit Error Probability for BPSK');
grid on;

%_______________________________________________%

% bit_error_prob = 0.5 * erfc(sqrt(EbN0_linear));

ber1 = 0.01;
ber2 = 0.00001;

x1 = 10*log10((erfcinv(2*ber1))^2);
x2 = 10*log10((erfcinv(2*ber2))^2);

x1_linear = 10^(x1/10);
x2_linear = 10^(x2/10);

disp(['Eb/N0 value in Linear for 10^-2 Bit Error Probability: ', num2str(x1_linear)]);
disp(['Eb/No value in dB  for 10^-2 Bit Error Probability: ', num2str(x1)]);

disp(['Eb/N0 value in Linear for 10^-5 Bit Error Probability: ', num2str(x2_linear)]);
disp(['Eb/No value in dB  for 10^-5 Bit Error Probability: ', num2str(x2)]);
