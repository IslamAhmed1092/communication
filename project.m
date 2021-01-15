[x1, fs1] = audioread('s1.wav');
[x2, fs2] = audioread('s2.wav');
[x3, fs3] = audioread('s3.wav');
%sound(y,fs)
% Parameters

T  = 1;

Fc1 = 50000;
Fc2 = 140000;
% Low-pass filter design
%[num,den] = butter(10,1.2*Fc/Fs); 

% extract one channel
y1 = x1(1:end,1)';
y2 = x2(1:end,1)';
y3 = x3(1:end,1)';

%padding signals 
max_l = max([length(y1),length(y2),length(y3)]);
y1 =[y1 zeros(1,max_l - length(y1))];
y2 =[y2 zeros(1,max_l - length(y2))];
y3 =[y3 zeros(1,max_l - length(y3))];


fs_new = 300000; 
% resample signals 
[y1, h1] = resample (y1, fs_new, fs1);
[y2, h2] = resample (y2, fs_new, fs2);
[y3, h3] = resample (y3, fs_new, fs3);
% Signals
t = 0:1/(length(y1)-1):T ;

c1 = cos(2*pi*Fc1*t);
c2 = cos(2*pi*Fc2*t);
c3 = sin(2*pi*Fc2*t);

r1 = y1 .*c1; 
r2 = y2 .* c2; 
r3 = y3 .* c3;
rt = y1 + y2 + y3;  
s = y1 .* c1 + y2 .*c2 + y3 .* c3; 

%sound(s,fs_new)

##Y_mags = abs(fft(s));
##num_bins = length(Y_mags);
##figure('Name','AM r1');
##plot([0:1/(num_bins/2 -1):1], Y_mags(1:num_bins/2)),grid on;
##title('Magnitude spectrum of modulated signal');
##xlabel('frequency (\pi rads/sample)');
##ylabel('Magnitude');
##
##% Plot
figure('Name','AM Modulated');
subplot(4,1,1); plot(t,y1); title('modulated signal1');

m1 = s .* c1 ;
[b,a ]= butter(1,2* 25000/fs_new); 
filtered1 = filter(b,a,m1);
sound(filtered1,fs_new);
subplot(4,1,2); plot(t,m1); title('extracted signal1');

m2 = s .* c2 ;
[b,a ]= butter(1,2* 25000/fs_new); 
filtered2 = filter(b,a,m2);
sound(filtered2,fs_new);

m3 = s .* c3 ;
[b,a ]= butter(1,2* 25000/fs_new); 
filtered3 = filter(b,a,m3);
sound(filtered3,fs_new);



