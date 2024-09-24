% Tarea N2 - Procesamiento Digital de Audio - Universidad de Chile
%===================================================================================================
%Estudiante: Nehemias Rivera 
%Profesor: Victor Espinoza C.
%Fecha: 01/09/2024
%===================================================================================================
%{
Ejercicio 1
Instrucción:
-Considerando lo visto en clases de procesos de modulacion de retardo,
disenhar un phaser estereofonico con modulacion senoidal. 
-Para incorporar la sensacion estereofonica, implemente una diferencia de 90° 
para el LFO en uno de los canales del phaser respecto del LFO del otro canal. 
Use la Figura 1 como referencia. 
-Simule la respuesta del phaser usando interpolacion lineal de retardo en los
LFOs considerando los parametros tL,R = 2 ms, fLFO = 2 Hz y tW = 0.5 ms, a 
fs = 44.1 kHz. Repita la simulacion cambiando tR = 4 ms; ¿Que diferencias 
auditivas percibe?, ¿El resultado auditivo es similar en fonos que en monitores?.
El codigo Matlab de mas abajo puede ser usado como punto de partida.
%}
clc;
close all;
clear;

% Para analisis espectral
nfft = 512;
window = hann(nfft);
noverlap = 0;
%% CAPTURA DE AUDIO ================================================================================
[x, fs] = audioread("Guitar.wav"); 

x = x(90*fs:100*fs,:);

x_L = x(:,1)';
x_R = x(:,2)';

N = length(x_L);
n = 0:(N-1);
t = n/fs;
%% PARAMETROS DE MODULACION ========================================================================
fLFO = 2;       % modulation frecuency

tL = 2e-3;
tR = 10e-3;

M0_L = tL*fs;   % predelay left
M0_R = tR*fs;   % predelay right


tW_L = 0.5e-3;
tW_R = 0.5e-3;

W_L  = tW_L*fs;      % depth left
W_R  = tW_R*fs;      % depth right

phaseShift = 90;% phase right modulation

if W_L>M0_L      
    M0_L = W_L;
end

if W_R>M0_R      
    M0_R = W_R;
end    
% retardo modulado
M_L = M0_L+(W_L)*sin(2*pi*n*fLFO/fs); 
M_R = M0_R+(W_R)*sin(2*pi*n*fLFO/fs+phaseShift*pi/180);
%% CALCULO PHASER ==================================================================================

y_L = phaser_linear_interp(x_L,M_L);
y_R = phaser_linear_interp(x_R,M_R);

% etapa de ganancia (dB)
dBg = 6;
y_L = y_L*10^(dBg/20);
y_R = y_R*10^(dBg/20);
%% REPRODUCCION DE AUDIO ===========================================================================

G=0.7;                  %Control dry/wet

Y_L = (1-G)*x_L + G*y_L;
Y_R = (1-G)*x_R + G*y_R;

audio = audioplayer([Y_L(:) Y_R(:)], fs); 
playblocking(audio);    %reproduccion dry+wet
%% PLOT ============================================================================================
%{
figure(1)
subplot 221
spectrogram(y_L,window,noverlap,nfft,fs,'yaxis')
title('Phaser linear interpolation Left - y(n)')
subplot 222
pwelch(y_L,window,noverlap,nfft,fs,'ms')
title('RMS Spectrum Left - y(n)')
rect = [400,100,550,600];
set(gcf,'Units','pixels')
set(gcf,'Position',rect)
ylim([-120 -10])
subplot 223
spectrogram(y_R,window,noverlap,nfft,fs,'yaxis')
title('Phaser linear interpolation Right - y(n)')
subplot 224
pwelch(y_R,window,noverlap,nfft,fs,'ms')
title('RMS Spectrum Right - y(n)')
rect = [400,100,550,600];
set(gcf,'Units','pixels')
set(gcf,'Position',rect)
ylim([-120 -10])

figure(2)
subplot 221
spectrogram(x_L,window,noverlap,nfft,fs,'yaxis')
title('Phaser linear interpolation Left - x(n)')
subplot 222
pwelch(x_L,window,noverlap,nfft,fs,'ms')
title('RMS Spectrum Left - x(n)')
rect = [400,100,550,600];
set(gcf,'Units','pixels')
set(gcf,'Position',rect)
ylim([-120 -10])
subplot 223
spectrogram(x_R,window,noverlap,nfft,fs,'yaxis')
title('Phaser linear interpolation Right - x(n)')
subplot 224
pwelch(x_R,window,noverlap,nfft,fs,'ms')
title('RMS Spectrum Right - x(n)')
rect = [400,100,550,600];
set(gcf,'Units','pixels')
set(gcf,'Position',rect)
ylim([-120 -10])
%}