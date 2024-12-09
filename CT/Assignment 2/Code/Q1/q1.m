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

%Part (a, b, c)

% figure(1);
% subplot(2,2,1);
% plot(t, msg_signal);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Message Signal');
% grid on;
% 
% multiplied_sig = multiplier_modulator(msg_signal, carrier_signal);
% 
% subplot(2,2,2);
% plot(t, multiplied_sig);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Multiplier Modulation');
% grid on;
% 
% non_linear_modulated = non_linear_modulator(msg_signal, carrier_signal, fs);
% 
% subplot(2,2,3);
% plot(t, non_linear_modulated);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Non-Linear Modulation');
% grid on;
% 
% switch_sig = square(2*pi*fc*t);
% switch_modulated_sig = switching_modulator(switch_sig, msg_signal, fs);
% 
% subplot(2,2,4);
% plot(t, switch_modulated_sig);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Switching Modulator');
% grid on;
% 
% sgtitle('Plots for different types of modulation');

% %Part (d): demodulator
% 

% switch_sig = square(2*pi*fc*t);
% switch_modulated_sig = switching_modulator(switch_sig, msg_signal, fs);
% demodulated_switch = demodulator(switch_modulated_sig, switch_sig, fs);
% 
% figure(2);
% subplot(2,1,1);
% plot(t, msg_signal);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Message Signal');
% grid on;
% 
% subplot(2,1,2);
% plot(t, demodulated_switch);
% xlabel('Time (t)');
% ylabel('Amplitude');
% title('Switching Demodulated Signal');
% grid on;
% 
% sgtitle('Demodulation using a Switching Demodulator');

%Part (e): phase shift effects

switch_sig = square(2*pi*fc*t);
switch_modulated_sig = switching_modulator(switch_sig, msg_signal, fs);

%part_i
delta_f_1 = 0;
delta_theta_1 = pi/3;
carrier_signal_shifted1 = square(2*pi*(fc+delta_f_1)*t+delta_theta_1);
demodulated_signal_shifted1 = demodulator(switch_modulated_sig, carrier_signal_shifted1, fs);

figure(3);
subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time (t)');
ylabel('Amplitude');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, switch_modulated_sig);
xlabel('Time (t)');
ylabel('Amplitude');
title('Modulated Shifted Carrier Wave signal');
grid on;

subplot(3,1,3);
plot(t, demodulated_signal_shifted1);
xlabel('Time (t)');
ylabel('Amplitude');
title('Demodulated Signal');
grid on;
sgtitle('Phase Shift Effect with pi/3 theta shift');


%part_ii
delta_f_2 = 5;
delta_theta_2 = 0;
carrier_signal_shifted2 = square(2*pi*(fc+delta_f_2)*t+delta_theta_2);
demodulated_signal_shifted2 = demodulator(switch_modulated_sig, carrier_signal_shifted2, fs);

figure(4);
subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time (t)');
ylabel('Amplitude');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, switch_modulated_sig);
xlabel('Time (t)');
ylabel('Amplitude');
title('Modulated Shifted Carrier Wave signal');
grid on;

subplot(3,1,3);
plot(t, demodulated_signal_shifted2);
xlabel('Time (t)');
ylabel('Amplitude');
title('Demodulated Signal');
grid on;
sgtitle('Phase Shift Effect with 5Hz frequency shift');

%part_iii
delta_f_3 = 5;
delta_theta_3 = pi/3;
carrier_signal_shifted3 = square(2*pi*(fc+delta_f_3)*t+delta_theta_3);
demodulated_signal_shifted3 = demodulator(switch_modulated_sig, carrier_signal_shifted3, fs);

figure(5);
subplot(3,1,1);
plot(t, msg_signal);
xlabel('Time (t)');
ylabel('Amplitude');
title('Message Signal');
grid on;

subplot(3,1,2);
plot(t, switch_modulated_sig);
xlabel('Time (t)');
ylabel('Amplitude');
title('Modulated Shifted Carrier Wave signal');
grid on;

subplot(3,1,3);
plot(t, demodulated_signal_shifted3);
xlabel('Time (t)');
ylabel('Amplitude');
title('Demodulated Signal');
grid on;
sgtitle('Phase Shift Effect with 5Hz frequency shift and pi/3 theta shift');
