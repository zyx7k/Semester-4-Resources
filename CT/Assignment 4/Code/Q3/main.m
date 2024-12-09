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
% It is important to note that rc is a column vector here

%% Transmitting Signal

transmit_filter_output = conv(upsampled_bpsk_signal, rc); % Rasised Cosine is our Transmit Filter
clear length;
transmit_signal = transmit_filter_output(1 : length(upsampled_bpsk_signal)+1); % To remove the extra zeros added by conv operator in the end of the signal

% Preliminary Plot
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

%% Reciever Side

recieve_filter = flipud(rc); % receive filter is now a row vector
recieved_signal = conv(transmit_signal, recieve_filter);

% to decide where to start sampling from to make a decision
figure(2);

subplot(2,1,1);
stem(transmit_signal);
title('Transmitted Bits by Transmit Filter');

subplot(2,1,2);
stem(recieved_signal);
title('Recieved Bits Processed by Recieve Filter')

sgtitle('Transmitted and Processed Recieved Bits');

% We have to sample every 4th sample from 9th sample onwards...

clear length;
sampled_bits = recieved_signal(9:4:length(recieved_signal)-1);

figure(3);
stem(sampled_bits);
title('Decision Bits');







