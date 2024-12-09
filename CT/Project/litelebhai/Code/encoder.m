function [inPhaseComponent, quadraturePhaseComponent] = encoder(digitalBits)

% Adding a zero at the end in case there are no even number of bits
N = length(digitalBits);
if(mod(N,2)~=0)
    digitalBits = horzcat(digitalBits, 0);
    N = N+1;
end

inPhaseComponent = [];
quadraturePhaseComponent = [];

a = 1; % Change according to needs

for k = 1 : N/2
    bit1 = digitalBits(2*k-1);
    bit2 = digitalBits(2*k);
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

% Plotting for example
% figure(1);
% subplot(3,1,1);
% stem(digitalSignal);
% xlabel('Sample Values');
% ylabel('Bit Stream');
% subplot(3,1,2);
% stem(inPhaseComponent);
% xlabel('Sample Values');
% ylabel('In Phase Component Value');
% subplot(3,1,3);
% stem(quadraturePhaseComponent);
% xlabel('Sample Values');
% ylabel('Quadrature Phase Component Value');
% sgtitle('Decoder Output for values: [0.1234, -0.4321, 1]')

end