clear vars;

fc = 10; % Carrier Frequency
Tb = 1;
Rb = 1/Tb;

delta_fb = 1/(2*Tb);
delta_fpe = 0.715/Tb;

samplesPerBit = 100; % Using 1000 Samples to represent the sinusioid corresponding to one bit of information

% Generating 1000 Bits
n = 1500;
messageBits = randi([0, 7], n, 1);

% Modulation
modulated_b = [];
modulated_pe = [];
time = [];

timeStep = 1/samplesPerBit;

for k = 1 : n
    t = (k-1)*Tb : timeStep : ((k*Tb)-timeStep);
    tempSignal_b = cos(2*pi*(fc + messageBits(k)*delta_fb)*t);
    tempSignal_pe = cos(2*pi*(fc + messageBits(k)*delta_fpe)*t);

    time = horzcat(time, t);
    modulated_b = horzcat(modulated_b, tempSignal_b);
    modulated_pe = horzcat(modulated_pe, tempSignal_pe);
end

% figure(1);
% plot(time, modulated_b);
% 
% figure(2);
% plot(time, modulated_pe);

snrvalues = 0 : 0.1: 10;
clear length;
prob_b_array = zeros(1, length(snrvalues));
prob_pe_array = zeros(1, length(snrvalues));

for p = 1 : length(snrvalues)
snr = snrvalues(p);
mod_b_temp = awgn(modulated_b, snr, 6.5); % considerng snr to be 3
mod_pe_temp = awgn(modulated_pe, snr, 6.5); % considering snr to be 3

mod_b_segregated = reshape(mod_b_temp, [], n);
mod_pe_segregated = reshape(mod_pe_temp, [], n);

demod_b_reference = ones(samplesPerBit, 8);
demod_pe_reference = ones(samplesPerBit, 8);

for k = 1:8
    demod_b_reference(:, k) = cos(2*pi*(fc+(k-1)*delta_fb)*(0:1/(samplesPerBit-1):1));
    demod_pe_reference(:, k) = cos(2*pi*(fc+(k-1)*delta_fpe)*(0:1/(samplesPerBit-1):1));
end

demod_out_b = zeros(2*samplesPerBit-1, n);
clear k;
clear length;

k = length(mod_b_segregated);
check_b = 0;
index_b = 0;
new_b = zeros(1, k);
for i = 1 : k
    index = 0;
    check = 0;
    for m = 1 :8
        demod = xcorr(mod_b_segregated(:, i), demod_b_reference(:,m));
        [temp] = max(demod);
        if(temp>check)
            check = temp;
            index = m;
            demod_out_b(:,i) = demod(:);
        end
    end
    new_b(i) = index-1;
end

demod_out_pe = zeros(2*samplesPerBit-1, n);
clear k;
clear length;

k = length(mod_pe_segregated);
check_pe = 0;
index_pe = 0;
new_pe = zeros(1, k);
for i = 1 : k
    index = 0;
    check = 0;
    for m = 1 :8
        demod = xcorr(mod_pe_segregated(:, i), demod_pe_reference(:,m));
        [temp] = max(demod);
        if(temp>check)
            check = temp;
            index = m;
            demod_out_pe(:,i) = demod(:);
        end
    end
   new_pe(i) = index-1;
end

different = 0;
for k = 1 : n
    if(new_b(k)~=messageBits(k))
        different = different+1;
    end
end

prob_b =different/n;
disp(prob_b);
prob_b_array(p) = prob_b;

different = 0;
for k = 1 : n
    if(new_pe(k)~=messageBits(k))
        different = different+1;
    end
end

prob_pe = different/n;
disp(prob_pe);
prob_pe_array(p) = prob_pe;

end

figure(3);
semilogy(snrvalues, prob_pe_array);
xlabel('SNR (dB)');
ylabel('B.E.R');
title(['P_e vs Eb/N0 for Probability Error Optimal']);

figure(4);
semilogy(snrvalues, prob_b_array);
xlabel('SNR (dB)');
ylabel('B.E.R');
title(['P_e vs Eb/N0 for Bandwidth Optimal']);

% Parameters for FFT and spectrum plotting
fftPoints = 2048; % Number of points in FFT for better resolution
fAxis = linspace(-Rb/2, Rb/2, fftPoints); % Frequency axis for plotting

% FFT and spectrum calculation
fftMod_b = fftshift(fft(modulated_b, fftPoints)); % Shift zero frequency to center
fftMod_pe = fftshift(fft(modulated_pe, fftPoints));

% Magnitude spectrum
spectrum_b = abs(fftMod_b/fftPoints); % Normalize the amplitude of FFT
spectrum_pe = abs(fftMod_pe/fftPoints);

% Plotting the spectrum
figure(5);
plot(fAxis, spectrum_b); % Add small value to avoid log(0)
title('Spectrum for Bandwidth Optimal Frequency Separation');
xlabel('Frequency (Hz), Normalized');
ylabel('Magnitude');
grid on;

figure(6);
plot(fAxis, spectrum_pe); % Logarithmic scale for dB
title('Spectrum for Probability Error Optimal Frequency Separation');
xlabel('Frequency (Hz), Normalized');
ylabel('Magnitude');
grid on;
