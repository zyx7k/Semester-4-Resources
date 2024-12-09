function lineCodedSignal = lineCoding_rect(encodedSignal)

% Upsample by the length of the filter for no ISI
upsampledSignal = upsample(encodedSignal, 17);

% Create Rectangular filter of length 17
rect_filter = ones(1,17);

% figure(1);
% plot(rect_filter);

lineCodedSignal = conv(upsampledSignal, rect_filter);

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
% sgtitle('Line Coder Output for values: [0.1234, -0.4321, 1] for Rect Filter');
end