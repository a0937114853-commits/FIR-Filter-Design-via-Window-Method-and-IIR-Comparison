% EE 3660 Intro to DSP
% HW3: IIR filter design through bilinear transformation
% HW4: FIR filter design, and performance comparison
% 
% Prof. Yi-Wen Liu, April 28, 2025

clear; close all;

omega_p = pi/3;

filename = 'Sffssfsssfs.m4a';
%filename = 'ABBA-flac2wav.wav'
[x,fs] = audioread(filename);
info = audioinfo(filename);

omega_s = 0.4*pi;
omega_cut = (omega_p+omega_s)/2;

N = 30; %% <--- STUDENTS: Please experiment different values of N
win = hann(2*N+1); % note that the filter order will be 2*N
B_fir = fir1(2*N,omega_cut/pi,"low",win); 

% Below were essentially the same starter codes from HW3
N_iir = 20; 
omega_corner = omega_p;
[B,A] = butter(N_iir,omega_corner/pi);

%% Making the plots
figure(1);
freqz(B,A);
handle = subplot(2,1,1);
set(handle,'ylim',[-100 10]);

[resps,freqs] = freqz(B_fir);
subplot(2,1,1)
hold on;
plot(freqs/pi,20*log10(abs(resps)));

legend('Butterworth','FIR')
subplot(2,1,2)
hold on;
plot(freqs/pi, unwrap(angle(resps))/pi*180);
x1 = x(:,1);
y_FIR = conv(B_fir,x1);
y_IIR = filter(B,A,x1);
%soundsc(y_IIR,fs);



































