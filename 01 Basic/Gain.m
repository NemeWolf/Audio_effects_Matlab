% ==================================================================================================
% Gain
% ==================================================================================================
% Nehemias Rivera - Universidad de Chile
% nehemias.rivera@ug.uchile.cl
% ==================================================================================================
clc
close all
clear
%% Audio capture ===================================================================================
directory = 'C:\Users\nehem\OneDrive - Universidad de Chile\Universidad\5to año\DSP Audio\Code_By_My\';
filename = 'Guitar.wav';
[x, fs] = audioread([directory filename]);
x = x(68*fs:80*fs,:);

N = length(x);
n = 0:(N-1);
t = n/fs;
%% Gain ============================================================================================
g_dB = -12;           % gain in dB
y = 10^(g_dB/20).*x;
%% Quantization noise ==============================================================================
p = 16;                                     % Bits
noise = -6*p;                               % Quantization noise  
dB_lim = noise-max(20*log10(abs(y(:,1))));  % Attenuation limit

atten_lim =  ones(size(y(:,1)))*10^(dB_lim/20);

% Remeber: Amplitude range between -1 and 1, and log scale between -Noise and 0

% Audio reproduction ===============================================================================
G=1;                  % Control dry/wet
Y = (1-G).*x + G.*y;
audio = audioplayer(Y, fs); 
playblocking(audio);

% Plot==============================================================================================

figure
plot(t,y(:,1),'r','linewidth',0.5)
hold on
plot(t, -atten_lim, 'k--', 'LineWidth', 0.5);     
plot(t, atten_lim, 'k--', 'LineWidth', 0.5);     
grid on
axis([0 N/fs -0.1 0.1 ])
xlabel('Time (s)')
ylabel('Amplitude')
title('Signal')
legend('y(n)*gain','Attenuation limit','location','southeast')