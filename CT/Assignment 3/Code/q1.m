t = 0:0.5 * 10 ^(-6):0.005;
mt = sin(2 * pi * 1000 * t);
int_mt = cumtrapz(t, mt);
% st_wrong = cos(2 * pi * 2000 * t + 2 * pi * 5000*int_mt);
% fc in wrong code is 2000, I have changed
% the single parameter fc to correct the code

% Value of various parameters
Fs = 10^6; %From first line
fm = 1000; %From second line
kf = 2*pi*5000; %From fourth line
fc_wrong = 2000; %From Question
fc = 8000; % (Consider)
delta_f = kf*1/(2*pi);
B = fm; % Bandwidth of the message sinewave
Bt = 2*(delta_f+B);

%Printing the values
disp(['Fs = ', num2str(Fs)]);
disp(['fm = ', num2str(fm)]);
disp(['fc (wrong one, given in question) = ', num2str(fc_wrong)]);
disp(['B = ', num2str(B)]);
disp(['df = ', num2str(delta_f)]);
disp(['Bt = ', num2str(Bt)]);

% To figure out whether it is NBFW or WBFM
% We have to check whether |kf*a(t)|<<1

check = kf*max(int_mt);
disp(['Value of |kf*a(t)| is  = ', num2str(check)]);

%Since the value is not small compared to 1, it is WBFM

% From now on, consider fc = 10000, reason for it will be
% clear in some time.


% Is Fs > 2(fc+Bt/2)?
RHS = 2*(fc_wrong+(Bt/2));
disp(['2(fc+Bt/2) = ', num2str(RHS)]);

%Clearly, Fs > 2(fc+Bt/2), so this condition is satisfied. 

% Is fc > Bt/2?
disp(['Bt/2 = ', num2str(Bt/2)]);

%Clearly, the old fc (2000) is not greater than Bt/2 i.e. 6000,
%thus leading to alaising. In order to correct the code, we thus
%use a value of fc higher than 6000, say 10000. 
%But we cannot take an even larger value of fc becasue then 
%Fs > 2(fc+Bt/2) criteria will not be satisfied. 

% Plotting the correct result:
st = cos(2 * pi * fc * t + 2 * pi * 5000*int_mt);
Sf = fftshift(fft(st));
f = linspace(-1e6, 1e6, length(Sf));
figure(1);
subplot (311),plot(t, mt),grid, title ('message m(t) ');
subplot (312), plot(t, st), grid, title ('FM s(t)');
subplot (313), plot(f, abs(Sf)), grid, title('|S(f)|');