clear all;
clc;

n = 12000;

n_bits = randbit(n); % Generating n bits randomly

bpsk_n_bits = bpskmap(n_bits); % Mapping these n bits via BPSK

display(n_bits); % Verifying
display(bpsk_n_bits); % Verifying

upsampled_bpsk_signal = upsample(bpsk_n_bits, 4); % Add 3 zeros between samples
%% Creating the Raised Cosine signal

a = 1;
m = 4; % Oversampling by 4 to get 4/T sampling rate
length = 1;
[rc,time] = raised_cosine(a,m,length);
plot(rc);
% It is important to note that rc is a column vector here

%% Transmitting Signal

transmit_filter_output = conv(upsampled_bpsk_signal, rc); % Rasised Cosine is our Transmit Filter
clear length;
transmit_signal = transmit_filter_output(1 : length(upsampled_bpsk_signal)+1); % To remove the extra zeros added by conv operator in the end of the signal

% Preliminary Plots
figure(1);
subplot(3,1,1);
stem(n_bits);
title('Generated Bits');

subplot(3,1,2);
stem(bpsk_n_bits);
title('BPSK Mapped Bits');

subplot(3,1,3);
stem(upsampled_bpsk_signal);
title('Upsampled BPSK Bits');

sgtitle('Bit Information')

%% Addition of Noise (Q4)

EbN0 = 4.3232; % Calculated in code of Q5  for B.E.R of 0.01
EbN0_linear = 10^(EbN0/10);

% Since we have BPS, the value of E[|b[n]|^2] will be equal to 1 as
% (b[n])^2 is always equal to 1. And also, gc is just 1, becuase ideal
% channel

% So esentially Es is nothing but the norm of gt, the transmit filter
% coefficients. This is norm-2 btw. 

Es = 0;
clear length;
for k = 1 : length(rc)
    Es = Es + rc(k)^2;
end

% For BPSK, bits per symbol is just 1
bit_per_symbol = 1;
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

title('Transmittd Bits by Transmit Filter');

subplot(2,1,2);
stem(recieved_signal);
title('Recieved Bits Processed by Recieve Filter')

sgtitle('Transmitted and Processed Recieved Bits');

% We have to sample every 4th sample from 9th sample onwards to make a decision...

clear length;
sampled_bits_recieved = recieved_signal(9:4:length(recieved_signal)-1);

%% Decision Statistics! (Q6)

figure(3);

subplot(2,1,1);
plot(real(sampled_bits_transmitted), imag(sampled_bits_transmitted), 'o');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Real vs Imag Plot at Transmitter');

subplot(2,1,2);
plot(real(sampled_bits_recieved), imag(sampled_bits_recieved), 'o');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Real vs Imag at Reciever');

sgtitle('Decision Statistics at Transmitter and Reciever');

%% Decision Time! (Q7)

bpsk_decision_on_transmitted = bpsk_decision(sampled_bits_transmitted);
bpsk_decision_on_recieved = bpsk_decision(sampled_bits_recieved);

error_transmit_decision = 0;
for k = 1 : length(bpsk_decision_on_transmitted)
    if(bpsk_decision_on_transmitted(k) ~= n_bits(k))
        error_transmit_decision = error_transmit_decision + 1;
    end
end

transmit_error_prob = error_transmit_decision/n;

error_recieve_decision = 0;
for k = 1 : length(bpsk_decision_on_recieved)
    if(bpsk_decision_on_recieved(k) ~= n_bits(k))
        error_recieve_decision = error_recieve_decision + 1;
    end
end

recieve_error_prob = error_recieve_decision/n;

disp('The Ideal Bit Error Probaility is 0.01');
disp(['Transmitter Decoding Error Probability is: ', num2str(transmit_error_prob)]);
disp(['Reciever Decoding Error Probability is: ', num2str(recieve_error_prob)]);