clc;
clear vars;

fs = 10^7; % Sampling rate
t = -0.03 : 1/fs: 0.03; % Time range

fc = 10^6; % Carrier frequency

% Creating the message signal and carrier signal
triangle1 = zeros(size(t));
triangle2 = zeros(size(t));
dc_offset = ones(size(t));

triangle1((-1 <= ((t+0.01)/0.01)) & (((t+0.01)/0.01) <= 1)) = (1-abs(((t((-1 <= ((t+0.01)/0.01)) & (((t+0.01)/0.01) <= 1))+0.01)/0.01)));
triangle2((-1 <= ((t-0.01)/0.01)) & (((t-0.01)/0.01) <= 1)) = (1-abs(((t((-1 <= ((t-0.01)/0.01)) & (((t-0.01)/0.01) <= 1))-0.01)/0.01)));

msg_signal = dc_offset + triangle1 - triangle2;
carrier_signal = cos(2*pi*fc*t);

% Modulation
modulated_sig = msg_signal .* carrier_signal;

% Demodulation
theta = 2*pi*fc*t;
v = modulated_sig .* cos(theta); % Multiply by carrier to shift to baseband

% Low-pass filtering
cutoff = 0.1*fc;
filtered = lowpass(v, cutoff, fs);

% Demodulated signal
demodulated_sig = filtered - mean(filtered); % Remove DC offset by finding the mean of the signal

% Plotting
figure(6);
subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time');
ylabel('Message Signal');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, modulated_sig);
xlabel('Time');
ylabel('Modulated Signal');
title('Modulated Signal');
grid on;

subplot(3,1,3);
plot(t, demodulated_sig);
xlabel('Time');
ylabel('Demodulated Signal');
title('Demodulated Signal');
grid on;
sgtitle('DSB-FC Modulation using rectifier demodulator')

%Spectra Plotting:
N = length(t);
frequencies = linspace(-fs/2, fs/2, N);
message_spectrum = abs(fftshift(fft(msg_signal)));
modulated_spectrum = abs(fftshift(fft(modulated_sig)));

figure(7);
subplot(2,1,1);
plot(frequencies, message_spectrum);
xlabel('Frequency (Hz)');
ylabel('Magnitude Spectrum of Message Signal');
title('Frequency Spectrum');

subplot(2,1,2);
plot(frequencies, modulated_spectrum);
xlabel('Frequency (Hz)');
ylabel('Magnitude Spectrum of Modualted Signal');
title('Frequency Spectrum');
sgtitle('Frequency Spectra of the message and modulated signal')

