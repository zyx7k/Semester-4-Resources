function digitalSignal = temp(analogSignal)

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

% Adding a zero at the end in case there are no even number of bits
N = length(digitalSignal);
if(mod(N,2)~=0)
    digitalSignal = horzcat(digitalSignal, 0);
    N = N+1;
end

inPhaseComponent = [];
quadraturePhaseComponent = [];

a = 1; % Change according to needs

for k = 1 : N/2
    bit1 = digitalSignal(2*k-1);
    bit2 = digitalSignal(2*k);
    if(bit1 == 0 && bit2 ==0)
        ak = a;
        bk = a;
    elseif(bit1==1 && bit2==0)
        ak = -a;
        bk = a;
    elseif(bit1==0 && bit2==1)
        ak = a;
        bk = -a;
    else
        ak = -a;
        bk = -a;
    end

    inPhaseComponent = [inPhaseComponent, ak];
    quadraturePhaseComponent = [quadraturePhaseComponent, bk];
end

% Upsample by the length of the filter for no ISI
upsampledSignal1 = upsample(inPhaseComponent, 17);
upsampledSignal2 = upsample(quadraturePhaseComponent, 17);

rolloff_factor = 1;
samples_per_symbol = 4;
filter_span_in_symbols = 2;
% Length of the filter is 17
[rc_filter, ~] = raised_cosine(rolloff_factor, samples_per_symbol, filter_span_in_symbols);
rc_filter_normalized = rc_filter / max(rc_filter);

lineCodedSignal1 = conv(upsampledSignal1, rc_filter_normalized);
lineCodedSignal2 = conv(upsampledSignal2, rc_filter_normalized);

fc = 10^6;
fs = 10*fc;
t = 0:1/fs:(length(lineCodedSignal1)/fs);
Tb = 17;
for count = 1:length(lineCodedSignal1)
    modInPhase(count) = lineCodedSignal1(count).*cos(2*pi*fc*t(count)+(pi/4));
    modQuadrature(count) = lineCodedSignal2(count).*sin(2*pi*fc*t(count)+(pi/4));
end
mod_sig1 = sqrt(2/Tb)*modInPhase + sqrt(2/Tb)*modQuadrature;



sigma = 0.1; % Vary from 0 to 1
rx_sig = channel_with_memory(mod_sig1, 0.8, 1, sigma);

t = 0:1/fs:(length(rx_sig)/fs);
for count = 1:length(rx_sig)
    out{1}(count) = 2*rx_sig(count).*cos(2*pi*fc*t(count) + pi/4);
    out{2}(count) = 2*rx_sig(count).*sin(2*pi*fc*t(count) + pi/4);
end

Fs = 48000;
out{1} = lowpass(out{1},50,Fs);
out{2} = lowpass(out{2},50,Fs);

N = length(out{1});
N = (N-16)/17;
lineDecodedSignal1 = ones(1, N);

for k = 0 : N-1
    sampledValue = out{1}(17*k+9);
    if(sampledValue<0)
        lineDecodedSignal1(k+1) = -1;
    end
end

N = length(out{2});
N = (N-16)/17;
lineDecodedSignal2 = ones(1, N);

for k = 0 : N-1
    sampledValue = out{2}(17*k+9);
    if(sampledValue<0)
        lineDecodedSignal2(k+1) = -1;
    end
end

    N = length(lineDecodedSignal1);
    decodedSignal = ones(1, 2*N);

    for k = 1 : N
        bit1 = lineDecodedSignal1(k);
        bit2 = lineDecodedSignal2(k);

        if(bit1 == 1 && bit2 == 1)
            ak = 0;
            bk = 0;
        elseif(bit1== -1 && bit2==1)
            ak = 1;
            bk = 0;
        elseif(bit1== 1 && bit2== -1)
            ak = 0;
            bk = 1;
        else
            ak = 1;
            bk = 1;
        end
        decodedSignal(2*k-1) = ak;
        decodedSignal(2*k) = bk;
    end


% figure(1);
% subplot(2,1,1);
% stem(digitalSignal);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Original Bits')
% subplot(2,1,2);
% stem(decodedSignal);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Decoded Bits')

sgtitle('Original Bits and Decoded Bits: [0.1234, -0.4321, 1] for Rect [Memory]');

end