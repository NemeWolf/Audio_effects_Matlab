%Tarea N2 - Procesamiento Digital de Audio - Universidad de Chile

%Estudiante: Nehemias Rivera 
%Profesor: Victor Espinoza C.
%Fecha: 01/09/2024

%Ejercicio 2

%Instrucción:

%{
Implementar un codigo computacional de compresion M/S

Muestre una aplicacion de la implementacion usando un segmento de audio stereo de maximo
20 segundos de duracion. Utilice graficos para mostrar tanto las senhales M y S con y sin
compresion, superponiendo la reduccion de ganancia.
%}

clc;
close all;
clear;

%% Captura audio ===================================================================================
filename = 'Drum.wav';
[x, fs] = audioread(filename);
x = x(68*fs:80*fs,:);

x_L = x(:,1)';
x_R = x(:,2)';

N = length(x);
n = 0:(N-1);
t = n/fs;
%% Codificacion MID/SIDE ===========================================================================
x_m  = (x_L + x_R)/2;
x_s  = (x_L - x_R)/2;
%% PARAMETROS DEL COMPRESOR ========================================================================
% Parametros MID
T_M   = -30 ;  % Threshold (dBFS)
R_M   = 8;     % Ratio
W_M   = 2;     % Knee (dB)
tA_M  = 30;    % Attack (milisegundos)
tR_M  = 80;    % Release (milisegundos)

% Parametros SIDE
T_S   = -26;   % Threshold (dBFS)
R_S   = 10;    % Ratio
W_S   = 2;     % Knee (dB)
tA_S  = 2;    % Attack (milisegundos)
tR_S  = 10;    % Release (milisegundos)
%% APLICAMOS COMPRESION ============================================================================
[y_m, A_m] = comp_sidechain(x_m, fs, tA_M, tR_M, T_M, R_M, W_M);
[y_s, A_s] = comp_sidechain(x_s, fs, tA_S, tR_S, T_S, R_S, W_S);

% Make up 
dBg_m  = 3;
dBg_s  = 3;
y_m   = y_m*10^(dBg_m/20);
y_s   = y_s*10^(dBg_s/20);
%% DECODIFICAION MID/SIDE ==========================================================================
ag = 1;     %Apertura stereo (0 a 1)
y_L = y_m + ag*y_s;
y_R = y_m - ag*y_s;
%% REPRODUCCION DE AUDIO ===========================================================================
G=1;                  %Control dry/wet

Y_L = (1-G)*x_L + G*y_L;
Y_R = (1-G)*x_R + G*y_R;

audio = audioplayer([Y_L(:) Y_R(:)], fs); 
playblocking(audio);  %reproduccion dry+wet
%% PLOT ============================================================================================ 
figure(1)
plot(t,x_m,'r','linewidth',0.5)
hold on
plot(t,y_m,'k-','linewidth',0.5)
plot(t,A_m,'b','linewidth',0.5)
hold off
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Comp mid')
legend('x(n)','y(n)','10^{L_{GR}(n)/20}','location','southeast')
figure(2)
plot(t,x_s,'r','linewidth',0.5)
hold on
plot(t,y_s,'k-','linewidth',0.5)
plot(t,A_s,'b','linewidth',0.5)
hold off
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Comp side')
legend('x(n)','y(n)','10^{L_{GR}(n)/20}','location','southeast')
%{
figure(1)
plot(t,20*log10(abs(x_m)),'r','linewidth',0.5)
hold on
plot(t,20*log10(abs(y_m)),'k-','linewidth',0.5)
plot(t,20*log10(abs(A_m)),'b','linewidth',0.5)
hold off
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Comp mid')
legend('x(n)','y(n)','10^{L_{GR}(n)/20}','location','southeast')
figure(2)
plot(t,20*log10(abs(x_s)),'r','linewidth',0.5)
hold on
plot(t,20*log10(abs(y_s)),'k-','linewidth',0.5)
plot(t,20*log10(abs(A_s)),'b','linewidth',0.5)
hold off
grid on
xlabel('tiempo (s)')
ylabel('amplitud')
title('Comp side')
legend('x(n)','y(n)','10^{L_{GR}(n)/20}','location','southeast')
%}