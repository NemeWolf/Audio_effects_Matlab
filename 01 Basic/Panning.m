% ==================================================================================================
% Panning - based precedence effect with level diferences (ILD)
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
x = x(100*fs:120*fs,:);
%% Temporal values =================================================================================
N = length(x);
n = 0:(N-1);
t = n/fs;
%% Initial Values ==================================================================================
alpha = 0.7;          %0=left - 1=right
%% Apply ===========================================================================================
[y, g_L, g_R]=paneo(x,alpha,'cuadratic');
%% Audio reproduction ==============================================================================
G=1;                  % Control dry/wet
Y = (1-G).*x + G.*y;
audio = audioplayer(Y, fs); 
playblocking(audio);
%% plot ============================================================================================
figure
subplot(2,1,1)
plot(t,y(:,1),'r','linewidth',0.5)
grid on
axis([0 N/fs -1.5*max(x(:,1)) 1.5*max(x(:,1)) ])
xlabel('Time (s)')
ylabel('Amplitude')
title('Left')
legend('y(n)*gain','location','southeast')
subplot(2,1,2)
plot(t,y(:,2),'r','linewidth',0.5)
grid on
axis([0 N/fs -1.5*max(x(:,2)) 1.5*max(x(:,2)) ])
xlabel('Time (s)')
ylabel('Amplitude')
title('Right')
legend('y(n)*gain','location','southeast')