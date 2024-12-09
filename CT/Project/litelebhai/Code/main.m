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

% Scatter Plot before Channel
% figure(1)
% scatter(lineCoded_sig{1}, lineCoded_sig{2});
% xlabel('In-Phase Values');
% ylabel('Quad-Phase Values');
% title('Constellation Diagram before Channel');
% grid on;

% Modulation
modulated_sig = modulate(lineCoded_sig);

% Noise Parameter
sigma = 0.01; % Vary from 0 to 1

% Adding Channel Noise: Memoryless
rx_sig = channel_memoryless(modulated_sig, sigma);

% Adding Channel Noise: Memory
% a = 0.8;
% b = 1;
% rx_sig = channel_with_memory(modulated_sig, a, b, sigma);

% Demodulation 
demod_sig = demodulate(rx_sig);

% Scatter Plot after Channelfigure(2)
% scatter(demod_sig{1}(1:10000), demod_sig{2}(1:10000));
% xlabel('In-Phase Values');
% ylabel('Quad-Phase Values');
% title('Constellation Diagram after Memoryless Channel');
% grid on;

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
fprintf('The Probability of error for sigma = %d is %d\n', sigma, p_e);

% Write the audio file
audiowrite("outputtest.wav", out, Fs);