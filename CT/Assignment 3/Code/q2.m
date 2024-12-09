fs = 400;
time = 0 : 1/fs : 1;
f = 25;
signal = 8*cos(2*pi*f*time);
plot(signal);

% Signal has to be between -7 to 7
bound = 7;

% Creating Levels
level_2bits = (2*bound)/(2^2);
level_6bits = (2*bound)/(2^6);

% Applying Quantization
quantized_2bits = round(signal/level_2bits)*level_2bits;
quantized_6bits = round(signal/level_6bits)*level_6bits;

% Finding the noise signal
noise_2bits = signal - quantized_2bits;
noise_6bits = signal - quantized_6bits;

% Calculating Quantization Error
qe_2bits = mean(abs(noise_2bits));
qe_6bits = mean(abs(noise_6bits));

% Displaying the Quantization Error
disp(['The quantization error for 2 bits is: ', num2str(qe_2bits)]);
disp(['The quantization error for 6 bits is: ', num2str(qe_6bits)]);

% --------------------(b)-------------------%

figure(1);
subplot(3,1,1);
stem(time, signal);
title('Original Signal');

subplot(3,1,2);
stem(time, quantized_2bits);
title('2-Bit Quantized Signal');

subplot(3,1,3);
stem(time, noise_2bits);
title('2-Bit Quantized Noise Signal');

figure(2);
subplot(3,1,1);
stem(time, signal);
title('Original Signal');

subplot(3,1,2);
stem(time, quantized_6bits);
title('6-Bit Quantized Signal');

subplot(3,1,3);
stem(time, noise_6bits);
title('6-Bit Quantized Noise Signal');
 
%------------(c)-------------%
noise_energy_2bits = noise_2bits.*noise_2bits;
noise_energy_6bits = noise_6bits.*noise_6bits;
signal_energy = signal.*signal;

snr_2bits = mean(signal_energy)/mean(noise_energy_2bits);
snr_6bits = mean(signal_energy)/mean(noise_energy_6bits);

disp(['2 bit snr: ', num2str(snr_2bits)]);
disp(['6 bit snr: ', num2str(snr_6bits)]);

