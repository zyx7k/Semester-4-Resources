clc;
clear all;
n = 10000;
snr_range = 0:0.5:10;
P_in = zeros(1,length(snr_range));
P_out = zeros(1,length(snr_range));

% Generate bits and map using Polar Signalling
bits_temp = randbit(n);
bpsk_bits = polarmap(bits_temp);

% Upsample the Polar signal
upsampled_bits = upsample(bpsk_bits, 4);

% Create Raised cosine filter
rolloff_factor = 0.5; 
samples_per_symbol = 4; 
filter_span_in_symbols = 2;
[rc_filter, ~] = raised_cosine(rolloff_factor, samples_per_symbol, filter_span_in_symbols);
rc_filter_normalized = rc_filter / max(rc_filter);

figure(10);
plot(rc_filter);

% Transmitter Side
transmitted_signal = conv(upsampled_bits, rc_filter_normalized);

% Define sampling points for received signal
sampling_point_start = samples_per_symbol * filter_span_in_symbols + 1;
sampling_points = sampling_point_start: samples_per_symbol: sampling_point_start + (length(bpsk_bits) * samples_per_symbol) - 1;

% Receiver filter
receive_filter = flipud(rc_filter_normalized);

for snr_idx = 1:length(snr_range)
    % Add noise to transmitted signal
    EbNo = snr_range(snr_idx);
    EbNo_linear = 10^(EbNo / 10);
    noise_power = (sum(rc_filter_normalized .^ 2) / samples_per_symbol) / EbNo_linear;
    sigma = sqrt(noise_power / 2);
    noise = sigma * (randn(size(transmitted_signal)) + 1j * randn(size(transmitted_signal)));
    noisy_signal = transmitted_signal + noise;

    % Sample the noisy signal for input and output of receiver
    sampled_input = noisy_signal(sampling_points);
    received_signal = conv(noisy_signal, receive_filter);
    sampled_output = received_signal(sampling_points + filter_span_in_symbols * samples_per_symbol);

    % Decision making and BER calculation
    bpsk_decision_transmit = bpsk_decision(sampled_input);
    bpsk_decision_receive = bpsk_decision(sampled_output);
    
    % Calculate input and output BER
    P_in(snr_idx) = mean(bpsk_decision_transmit ~= bits_temp);
    P_out(snr_idx) = mean(bpsk_decision_receive ~= bits_temp);

    figure(1);
    subplot(5,1,1);
    stem(upsampled_bits);
    title('Example bits')
    subplot(5,1,2);
    stem(noisy_signal);
    title('Transmitted Signal');
    subplot(5,1,3);
    stem(bpsk_decision_transmit);
    title('Decision on Transmitted Signal');
    subplot(5,1,4);
    stem(received_signal);
    title('Recieved Signal');
    subplot(5,1,5);
    stem(bpsk_decision_receive);
    title('Decision on Recieved Signal');
end

% Plot BER vs SNR
figure(2);
plot(snr_range, P_out, 'LineWidth', 2, 'Color', 'green');
hold on;
plot(snr_range, P_in, 'LineWidth', 2, 'Color',  'red');
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR for Raised Cosine pulse');
legend('P_{out}', 'P_{in}', 'Location', 'northeast');
grid on;
