[stereoAudio, Fs] = audioread("project.wav"); % Read the audio file
monoAudio = (stereoAudio(:,1))'; % Monoaudio is now a row vector
digitalBits = a2d(monoAudio); % Stream of bits

% Send bits to the encoder
encoded_sig = cell(1,2); % preallocating a cell for inPhase component and quadrature phase components
[encoded_sig{1},encoded_sig{2}] = encoder(digitalBits);

lineCoded_sig = cell(1,2); % preallocating a cell for inPhase lineCodinand quadrature phase lineCoding

% LineCoding using raised Cosine
% lineCoded_sig{1} = lineCoding_raisedCosine(encoded_sig{1});
% lineCoded_sig{2} = lineCoding_raisedCosine(encoded_sig{2});

% LineCoding using rectangular
lineCoded_sig{1} = lineCoding_rect(encoded_sig{1});
lineCoded_sig{2} = lineCoding_rect(encoded_sig{2});

% Modulation
modulated_sig = modulate(lineCoded_sig);

EbN0_dB = 0:1:30;
prob_error = [];
for p = 1 : length(EbN0_dB)

    EbN0_linear = 10.^(EbN0_dB(p) / 10);
    Es = 17;

    Eb = Es/2;
    N0 = Eb./EbN0_linear;

    % Noise parameter
    sigma = sqrt(N0/2);

    % Adding Channel Noise: Memoryless
    % rx_sig = channel_memoryless(modulated_sig, sigma);

    % Adding Channel Noise: Memory
    a = 0.8;
    b = 1;
    rx_sig = channel_with_memory(modulated_sig, a, b, sigma);

    % Demodulation
    demod_sig = demodulate(rx_sig);

    % Line Decoding
    decoded_sig = cell(1,2);
    decoded_sig{1} = lineDecoding(demod_sig{1});
    decoded_sig{2} = lineDecoding(demod_sig{2});

    % Decoder
    digits = decoder(decoded_sig{1},decoded_sig{2});
    out = d2a(digits);
    out = out/max(out);

    % Finding Probability of error
    N = length(digits);
    differences = 0;
    for k = 1 : N
        if(digits(k)~=digitalBits(k))
            differences = differences + 1;
        end
    end

    p_e = differences/N;
    prob_error = [prob_error, p_e];
    fprintf('The Probability of error for sigma = %d is %d\n', sigma, p_e);
end

% Plot P_e vs SNR
figure(2);
semilogy(EbN0_dB, prob_error, 'LineWidth', 2, 'Color', 'green');
xlabel('SNR (dB)');
ylabel('P_e');
title('P_e vs SNR for Rectangular Pulse in Memory Channel with a=0.8, b=1');
grid on;

% Write the audio file
audiowrite("outputtest.wav", out, Fs);