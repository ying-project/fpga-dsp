y = filter(Hd, x); % filter generated from Filter Design App, see image in readme
plot(t,x,t,y)
xlim([0 0.1])

xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')

writematrix(int16(y * 2^15),'output.txt');