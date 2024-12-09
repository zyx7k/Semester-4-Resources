clear all;
clc;

n = 12000; % Using 10000 instead of 12000 for now

n_bits = randbit(n); % Generating n bits randomly

psk_n_bits = eightpskmap(n_bits); % Mapping these n bits via psk

display(n_bits); % Verifying
display(psk_n_bits); % Verifying

upsampled_psk_signal = upsample(psk_n_bits, 4); % Add 3 zeros between samples
%% Creating the Raised Cosine signal

a = 1;
m = 4; % Oversampling by 4 to get 4/T sampling rate
length = 1;
[rc,time] = raised_cosine(a,m,length);
% It is important to note that rc is a column vector here

%% Transmitting Signal

transmit_filter_output = conv(upsampled_psk_signal, rc); % Rasised Cosine is our Transmit Filter
clear length;
transmit_signal = transmit_filter_output(1 : length(upsampled_psk_signal)+1); % To remove the extra zeros added by conv operator in the end of the signal

% Preliminary Plot
figure(1);
subplot(3,1,1);
stem(n_bits);
title('Generated Bits');

subplot(3,1,2);
stem(psk_n_bits);
title('psk Mapped Bits');

subplot(3,1,3);
stem(upsampled_psk_signal);
title('Upsampled psk Bits');

sgtitle('Bit Information')

%% Addition of Noise

EbN0 = 4.2284; % Calculated in code of Q8 for Bit Error Probability of 10^-2, because Eb/N0 Bit Error probability is same as 4PAM
EbN0_linear = 10^(EbN0/10);

% Esentially Es is nothing but the norm of gt, the transmit filter
% coefficients. This is norm-2 btw. 

Es = 0;
clear length;
for k = 1 : length(rc)
    Es = Es + rc(k)^2;
end

% For psk, bits per symbol is just 1
bit_per_symbol = 3;
Eb = Es/bit_per_symbol;

N0 = Eb/EbN0_linear;
sigma = sqrt(N0/2);

clear length;
N = length(transmit_signal);
real_part = sigma * randn(1, N);
imag_part = sigma * randn(1, N);
noise = complex(real_part, imag_part);

transmit_signal = transmit_signal+noise;

% We have to sample every 4th sample from 5th sample onwards to get the sampled bits at transmitter end...

clear length;
sampled_bits_transmitted = transmit_signal(5:4:length(transmit_signal)-1);

%% Reciever Side

recieve_filter = flipud(rc); % receive filter is now a row vector
recieved_signal = conv(transmit_signal, recieve_filter);

% To decide where to start sampling from to make a decision
figure(2);

subplot(2,1,1);
stem(transmit_signal);
title('Transmitted Bits by Transmit Filter');

subplot(2,1,2);
stem(recieved_signal);
title('Recieved Bits Processed by Recieve Filter')

sgtitle('Transmitted and Processed Recieved Bits');

% We have to sample every 4th sample from 9th sample onwards to make a decision...

clear length;
sampled_bits_recieved = recieved_signal(9:4:length(recieved_signal)-1);

%% Decision Statistics!

figure(3);

subplot(1,2,1);
plot(real(sampled_bits_transmitted), imag(sampled_bits_transmitted), 'o');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Real vs Imag Plot at Transmitter for 8PSK');

subplot(1,2,2);
plot(real(sampled_bits_recieved), imag(sampled_bits_recieved), 'o');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Real vs Imag at Reciever');

sgtitle('Decision Statistics at Transmitter and Reciever for 8PSK');

%% Decision Time!
 
psk_decision_on_transmitted = decision_psk(sampled_bits_transmitted);
psk_decision_on_recieved = decision_psk(sampled_bits_recieved);

error_transmit_decision = 0;
for k = 1 : length(psk_decision_on_transmitted)
    if(psk_decision_on_transmitted(k) ~= psk_n_bits(k))
        error_transmit_decision = error_transmit_decision + 1;
    end
end

transmit_error_prob = 3*error_transmit_decision/n;

error_recieve_decision = 0;
for k = 1 : length(psk_decision_on_recieved)
    if(psk_decision_on_recieved(k) ~= psk_n_bits(k))
        error_recieve_decision = error_recieve_decision + 1;
    end
end

recieve_error_prob = 3*error_recieve_decision/n;

disp('The Ideal Bit Error Probability is 0.01');
disp(['Transmitter Decoding Error Probability is: ', num2str(transmit_error_prob)]);
disp(['Reciever Decoding Error Probability is: ', num2str(recieve_error_prob)]);
