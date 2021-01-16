[x1, fs1] = audioread('s1.wav');
[x2, fs2] = audioread('s2.wav');
[x3, fs3] = audioread('s3.wav');
%sound(y,fs)
% Parameters
function y1 = lowpassFilter(fc,fs,signal)
  [b,a ]= butter(6, 2 * fc/fs); 
  y1 = filter(b,a,signal);
endfunction

function dispSpectrum(singal, fs, t)
  df=fs/length(singal);
  frequency_audio=-fs/2:df:fs/2-df;
  figure
  FFT_audio_in=fftshift(fft(singal));
  plot(frequency_audio,abs(FFT_audio_in));
  title(t);
  xlabel('Frequency(Hz)');
  ylabel('Amplitude');
endfunction

function demodulate(s,phase,fs_new,fs1,fs2,fs3,Fc1,Fc2,t)
  c1 = cos(2*pi*Fc1*t+phase); % Fc1 40000
  c2 = cos(2*pi*Fc2*t+phase); % Fc2 100000
  c3 = sin(2*pi*Fc2*t+phase);
  ##########singal y1 extract #################
##  dispSpectrum(s,fs_new,"bandpass s1"); 
  m1 = s .* c1' ;
##  dispSpectrum(m1,fs_new,"shifted m1"); 
  m1 = lowpassFilter(20000,fs_new,m1); 
  [m1, h1] = resample (m1, fs1,fs_new);
  sound(m1,fs1);
  ##########singal y2 extract #################
  ##dispSpectrum(s2,fs_new,"bandpass s2"); 
  m2 = s .* c2' ;
  ##dispSpectrum(m2,fs_new,"shifted m2"); 
  m2 = lowpassFilter(20000,fs_new,m2); 
  [m2, h1] = resample (m2, fs2,fs_new);
  sound(m2,fs2);
  ##########singal y3 extract #################
  m3 = s .* c3' ;
  ##dispSpectrum(m3,fs_new,"shifted m3"); 
  m3 = lowpassFilter(20000,fs_new,m3); 
  [m3, h1] = resample (m3, fs3,fs_new);
  sound(m3,fs3);
  % display spectrum
endfunction
################# global variables #############
Fc1 = 40000;
Fc2 = 100000;
T  = 1;
fs_new = 300000; 

% extract one channel
y1 = x1(:,2)+x1(:,1);
y2 = x2(:,2)+x2(:,1);
y3 = x3(:,2)+x3(:,1);

##y1 = lowpassFilter(20000,fs1,y1); 
##y2 = lowpassFilter(20000,fs2,y2); 
##y3 = lowpassFilter(20000,fs3,y3); 

%padding signals 
max_l = max([length(y1),length(y2),length(y3)]);
y1 =[y1; zeros(max_l - length(y1),1)];
y2 =[y2; zeros(max_l - length(y2),1)];
y3 =[y3; zeros(max_l - length(y3),1)];
 
% resample signals 
[y1, h1] = resample (y1, fs_new, fs1);
[y2, h2] = resample (y2, fs_new, fs2);
[y3, h3] = resample (y3, fs_new, fs3);
##dispSpectrum(y1,fs_new,"y1");
##dispSpectrum(y2,fs_new,"y2");
##dispSpectrum(y3,fs_new,"y3");
% Signals
duration = length(y1)/fs_new;
t= -(duration - 1/fs_new)/2:1/fs_new:(duration-1/fs_new)/2;

% modulation
c1 = cos(2*pi*Fc1*t); % Fc1 40000
c2 = cos(2*pi*Fc2*t); % Fc2 100000
c3 = sin(2*pi*Fc2*t);

r1 = y1 .* c1'; 
r2 = y2 .* c2'; 
r3 = y3 .* c3';
##rt = y1 + y2 + y3;  
s = r1 + r2 + r3; 
##dispSpectrum(s,fs_new,"s"); 

demodulate(s, 0, fs_new,fs1,fs2,fs2,Fc1,Fc2,t); 
demodulate(s, 10 * pi/180, fs_new,fs1,fs2,fs2,Fc1,Fc2,t); 
demodulate(s, 20 * pi/180, fs_new,fs1,fs2,fs2,Fc1,Fc2,t); 
demodulate(s, 90 * pi/180, fs_new,fs1,fs2,fs2,Fc1,Fc2,t); 




