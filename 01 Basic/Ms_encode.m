% ==================================================================================================
% MID - SIDE Encode
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

x_L = x(:,1)';
x_R = x(:,2)';
%% Temporal values =================================================================================
N = length(x);
n = 0:(N-1);
t = n/fs;
%% Codificacion MID/SIDE ===========================================================================
y_m  = (x_L + x_R)/2;
y_s  = (x_L - x_R)/2;
%% DECODIFICAION MID/SIDE ==========================================================================
ag = 1;     %Apertura stereo (0 a 1)

y_L = y_m + ag*y_s;
y_R = y_m - ag*y_s;
%% REPRODUCCION DE AUDIO ===========================================================================
G=1;                  %Control dry/wet

Y_L = (1-G)*x_L + G*y_L;
Y_R = (1-G)*x_R + G*y_R;

audio = audioplayer([Y_L(:) Y_R(:)], fs); 
%playblocking(audio);  %reproduccion dry+wet
%% PLOT ============================================================================================ 

figure(1)
subplot(2,1,1)
plot(t,y_m,'r','linewidth',0.5)
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Mid')
legend('y_m','location','southeast')
subplot(2,1,2)
plot(t,y_s,'k-','linewidth',0.5)
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Side')
legend('y_s','location','southeast')