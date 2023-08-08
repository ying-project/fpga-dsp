%%Time specifications:
Fs = 8000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.25;             % seconds
t = (0:dt:StopTime-dt)';     % seconds

%%Sine wave:
Fc = 6;                     % hertz
x = 0.5 * sin(2*pi*Fc*t) + 0.5 * sin(200*pi*Fc*t);

% Plot the signal versus time:
figure;
plot(t,x);
xlabel('time (in seconds)');
title('Signal versus Time');

writematrix(int16(x * 2^15),'input.txt');
