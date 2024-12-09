function lineCodedSignal = lineCoding_raisedCosine(encodedSignal)

% Upsample by the length of the filter for no ISI
upsampledSignal = upsample(encodedSignal, 17);

% Create Raised cosine filter
rolloff_factor = 1;
samples_per_symbol = 4;
filter_span_in_symbols = 2;
% Length of the filter is 17
[rc_filter, ~] = raised_cosine(rolloff_factor, samples_per_symbol, filter_span_in_symbols);
rc_filter_normalized = rc_filter / max(rc_filter);

figure(1);
plot(rc_filter);

lineCodedSignal = conv(upsampledSignal, rc_filter_normalized);

% Plotting for example
% figure(1);
% subplot(4,1,1);
% stem(inPhaseComponent);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('In Phase Component');
% subplot(4,1,2);
% plot(lineCodedSignal1);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Line Coded In Phase Component')
% subplot(4,1,3);
% stem(quadraturePhaseComponent);
% xlabel('Sample Values');
% ylabel('Amplitude Value');
% title('Quadrature Phase Component');
% subplot(4,1,4);
% plot(lineCodedSignal2);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Line Coded Quadrature Phase');
% sgtitle('Line Coder Output for values: [0.1234, -0.4321, 1] for Filter');

end