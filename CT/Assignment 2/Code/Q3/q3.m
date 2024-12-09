clear variables

fs = 10^7; %saampling rate i've chosen
t = -0.03 : 1/fs: 0.03; %time range for discretization

fc = 10^6; %carrier wave frequency

%creating the message signal and carrier signal
triangle1 = zeros(size(t));
triangle2 = zeros(size(t));

triangle1((-1 <= ((t+0.01)/0.01)) & (((t+0.01)/0.01) <= 1)) = (1-abs(((t((-1 <= ((t+0.01)/0.01)) & (((t+0.01)/0.01) <= 1))+0.01)/0.01)));
triangle2((-1 <= ((t-0.01)/0.01)) & (((t-0.01)/0.01) <= 1)) = (1-abs(((t((-1 <= ((t-0.01)/0.01)) & (((t-0.01)/0.01) <= 1))-0.01)/0.01)));

msg_signal = triangle1 - triangle2;
carrier_signal = (cos(2*pi*fc*t));

% FM and PM Modulation
kf = 1;
phase_deviation_fm = 2*pi*kf*cumsum(msg_signal);
fm_sig = cos(2*pi*fc*t + phase_deviation_fm);

kp=1;
phase_deviation_pm = 2*pi*kp*msg_signal;
pm_sig = cos(2*pi*fc*t + phase_deviation_pm);

figure(8);

subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time');
ylabel('Amplitude');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, fm_sig);
xlabel('Time');
ylabel('Amplitude');
title('FM Signal');
grid on;

subplot(3,1,3);
plot(t, pm_sig);
xlabel('Time');
ylabel('Amplitude');
title('PM Signal');
grid on;
sgtitle('Modulation: FM and PM');

%demodulation:
fm_demod = abs(hilbert(fm_sig));
pm_demod = abs(hilbert(pm_sig));

figure(9);

subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time');
ylabel('Amplitude');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, fm_demod);
xlabel('Time');
ylabel('Amplitude');
title('Demodulated FM Signal');
grid on;

subplot(3,1,3);
plot(t, pm_demod);
xlabel('Time');
ylabel('Amplitude');
title('Demodulated PM Signal');
grid on;
sgtitle('Demodulation: FM and PM');

%spectras;

msg_spectrum = fftshift(fft(msg_signal));
fm_spectrum = fftshift(fft(fm_sig));
pm_spectrum = fftshift(fft(pm_sig));
freq = linspace(-fs/2, fs/2, length(t));

% Plotting
figure(10);

subplot(3,1,1);
plot(freq, abs(msg_spectrum));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Message Signal Spectrum');
grid on;

subplot(3,1,2);
plot(freq, abs(fm_spectrum));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FM Signal Spectrum');
grid on;

subplot(3,1,3);
plot(freq, abs(pm_spectrum));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('PM Signal Spectrum');
grid on;

sgtitle('Frequency Spectra of Message, PM and AM Signals');


