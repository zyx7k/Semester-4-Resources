function analogSignal = d2a(digitalSignal)

stereoAudio = audioread("project.wav");
monoAudio = stereoAudio(:,1)'; % monoAudio is now a row vector
maxAmplitude = max(monoAudio);

N = length(digitalSignal) / 14; % Number of symbols
decimalArray = zeros(1, N); % Preallocation for speed

% Reshape the 1D digital signal into a matrix where each row has 14 bits
binaryMatrix = reshape(digitalSignal, 14, N)';

% Convert each binary row to a decimal number
powersOfTwo = 2.^(13:-1:0);  % Array of powers of two
decimalArray = binaryMatrix * powersOfTwo';

% Scale the decimal array to match the original analog scaling
decimalArray = (decimalArray / 10^4) - 0.5;
analogSignal = decimalArray * (2 * maxAmplitude);

end