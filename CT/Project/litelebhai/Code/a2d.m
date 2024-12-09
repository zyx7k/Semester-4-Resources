function digitalSignal = a2d(analogSignal)

% Get the signal in the range [-0.5, 0.5]
maxAmplitude = max(abs(analogSignal));
analogSignal = analogSignal / (2 * maxAmplitude);

% We want correct up to 4 decimal places
precision = 4;

% Scale to integer values
scaledSignal = round((analogSignal + 0.5) * 10^precision);

% Minimum number of binary digits required to represent the decimal number
minDigits = ceil(precision / log10(2)); % which comes out to be 14

% Convert entire array to binary strings at once and then to bits
binaryStrings = dec2bin(scaledSignal, minDigits);
digitalSignal = reshape(binaryStrings' - '0', 1, []);

% This results in a single row vector of bits that represents the digital signal

% For Plotting
% stem(digitalSignal);
% xlabel('Sample Number');
% ylabel('Bit Value');
% title('Output of A/D converter for values: [0.1234, -0.4321, 1]');

% debug: disp(digitalSignal);

end