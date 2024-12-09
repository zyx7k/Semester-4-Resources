function mod_sig = modulate(sig)
fc = 10^6;
fs = 10*fc;
t = 0:1/fs:(length(sig{1})/fs);
Tb = 17;
for count = 1:length(sig{1})
    modInPhase(count) = sig{1}(count).*cos(2*pi*fc*t(count)+(pi/4));
    modQuadrature(count) = sig{2}(count).*sin(2*pi*fc*t(count)+(pi/4));
end

mod_sig = sqrt(2/Tb)*modInPhase + sqrt(2/Tb)*modQuadrature;

% Plotting for example
% figure(1);
% subplot(4,1,1);
% plot(lineCodedSignal1);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Line Coded In Phase Component')
% subplot(4,1,2);
% plot(modInPhase);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Modulated In Phase Component')
% subplot(4,1,3);
% plot(lineCodedSignal2);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Line Coded Quadrature Phase');
% subplot(4,1,4);
% plot(modQuadrature);
% xlabel('Sample Values');
% ylabel('Amplitude Values');
% title('Modulated Quad Phase Component')
% sgtitle('Modulator Output for values: [0.1234, -0.4321, 1] for Rect Filter');

end