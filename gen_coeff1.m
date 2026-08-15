clear all; clc;
fs = 8000;      % Sampling frequency 8kHz
fc = 1000;      % Cutoff frequency 1kHz  
N = 16;         % Filter order = 16 taps

% Design Low Pass FIR using Hamming window
h = fir1(N-1, fc/(fs/2), 'low', hamming(N));

% Convert to Q1.12 fixed point for hardware: multiply by 4096
Q = 12;
h_q = round(h * 2^Q);

disp('Quantized Coefficients:');
disp(h_q);

% Save to file for Verilog
fid = fopen('coeff.txt','w');
for i = 1:N
    fprintf(fid, '%d\n', h_q(i));
end
fclose(fid);

% Plot frequency response
freqz(h,1,512,fs);
title('16-Tap Low Pass FIR Response');
