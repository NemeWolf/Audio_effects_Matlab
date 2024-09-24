% ==================================================================================================
%% Fade in-out
% ==================================================================================================
% Nehemias Rivera - Universidad de Chile
% nehemias.rivera@ug.uchile.cl
% ==================================================================================================
% This file can apply three types of fades (exponential, logaritmic and s
% shape) and graph the results. Also apply crossfades section with two
% audio files
% ==================================================================================================
clc
close all
clear
%% Audio capture ===================================================================================
directory = 'C:\Users\nehem\OneDrive - Universidad de Chile\Universidad\5to año\DSP Audio\Code_By_My\';
filename = 'Guitar.wav';
[x, fs] = audioread([directory filename]);
x = x(100*fs:120*fs,1)';

N = length(x);
n = 0:(N-1);
t = n/fs;
%% Initial Values ==================================================================================
t0 = 0;        % initial fade (second)
t1 = 5;        % final fade (second)
n0 = t0*fs;
n1= t1*fs;
beta = 5;
dB_G = -5;
%% Apply fade ======================================================================================
[y,G_fade]=fade(x,fs,n0,n1,'s','in',2);    % Use help
%% Audio reproduction ==============================================================================
G=1;                  % Control dry/wet
Y = (1-G).*x + G.*y;
audio = audioplayer(Y, fs); 
playblocking(audio);
%% plot ============================================================================================
figure
plot(t,x,'b','linewidth',0.5)
hold on
plot(t,y, 'r', 'LineWidth', 0.5);     
plot(t, G_fade*max(x(n0+1:n1)), 'k--', 'LineWidth', 1);     
plot(t, -G_fade*max(x(n0+1:n1)), 'k--', 'LineWidth', 1);     
grid on
axis([0 N/fs -0.5 0.5 ])
xlabel('Time (s)')
ylabel('Amplitude')
title('Fade')
legend('x(n)','y(n)','Fade shape','location','southeast')
%% Crossfade =======================================================================================
%in
directory = 'C:\Users\nehem\OneDrive - Universidad de Chile\Universidad\5to año\DSP Audio\Code_By_My\';
filename = 'Guitar.wav';
[x_1, fs_1] = audioread([directory filename]);
x_1 = x_1(68*fs_1:80*fs_1,1)';
N_1 = length(x_1);
n_1 = 0:(N_1-1);
t_1 = n_1/fs_1;
t0_1 = 0;       
t1_1 = 12;       
n0_1 = t0_1*fs_1;
n1_1 = t1_1*fs_1;
%out
directory = 'C:\Users\nehem\OneDrive - Universidad de Chile\Universidad\5to año\DSP Audio\Code_By_My\';
filename = 'Drum.wav';
[x_2, fs_2] = audioread([directory filename]);
x_2 = x_2(68*fs_2:80*fs_2,1)';
N_2 = length(x_2);
n_2 = 0:(N_2-1);
t_2 = n_2/fs_2;
t0_2 = 0;        
t1_2 = 12;        
n0_2 = t0_2*fs_2;
n1_2 = t1_2*fs_2;
x=x_1+x_2;
%% Apply fade to signals ===========================================================================
[y_1,G_fade_1]=fade(x_1,fs_1,n0_1,n1_1,'exp','in',2);    
[y_2,G_fade_2]=fade(x_2,fs_2,n0_2,n1_2,'exp','out',2); 
y = y_1+y_2;
%% Audio reproduction ==============================================================================
G=1;                  % Control dry/wet
Y = (1-G).*x + G.*y;
audio = audioplayer(Y, fs); 
playblocking(audio);
%% plot ============================================================================================
figure
plot(t_1,y_1,'b','linewidth',0.5)
hold on
plot(t_2,y_2, 'r', 'LineWidth', 0.5);     
plot(t_1, G_fade_1*max(x_1(n0+1:n1)), 'k--', 'LineWidth', 1);     
plot(t_2, G_fade_2*max(x_2(n0+1:n1)), 'k--', 'LineWidth', 1);    
plot(t_1, -G_fade_1*max(x_1(n0+1:n1)), 'k--', 'LineWidth', 1);     
plot(t_2, -G_fade_2*max(x_2(n0+1:n1)), 'k--', 'LineWidth', 1);    
grid on
axis([0 N_1/fs_1 -0.5 0.5 ])
xlabel('Time (s)')
ylabel('Amplitude')
title('Crossfade')
legend('x(n)','y(n)','Fade shape','location','southeast')