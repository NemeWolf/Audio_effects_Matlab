function [y,A] = comp_sidechain(x,fs, tA, tR, T, R, W)
%=================================================
% Compresor Sidechain
%=================================================
%Input
%x: input signal
%fs: sampling rate
%tA: Attack time (ms)
%tR: Release time (ms)
%T: Threshold (dBFS)
%R: Ratio
%W: Knee (dB)
%=================================================
%Output
%y: output signal
%A: linear amplitude scalar
%=================================================

Lx_dB = 20*log10((abs(x) + randn(size(x))*1e-6*1)); 

N = length(x);

% temporary parameters

tAttack  = tA/1000; % Attack (segundos)
tRelease = tR/1000; % Release (segundos)

alpha_A = exp(-(log(9)/(fs*tAttack)));
alpha_R = exp(-(log(9)/(fs*tRelease)));

% prelocating
CV      = zeros(1,N);
L_delta = zeros(1,N);
L_GR    = zeros(1,N);
A       = zeros(1,N);
y       = zeros(1,N);
L_GR_1  = 0;
 
for n = 1:N

    % Apply static process
    
    if Lx_dB(n) > (T + W/2)     % above threshold
        CV(n) = T + (Lx_dB(n) - T)/R;
    elseif Lx_dB(n) > (T - W/2) % Knee range
        CV(n) = Lx_dB(n) + ...
            ((1/R - 1)*(Lx_dB(n) - T + W/2)^2)/(2 * W);
    else                        % Below threshold
        CV(n) = Lx_dB(n);
    end
    
    % Apply envelope process
    
    L_delta(n) = CV(n) - Lx_dB(n);
    
    if L_delta(n) < L_GR_1 
        % attack
        L_GR(n) = ((1-alpha_A)*L_delta(n))+(alpha_A*L_GR_1);
    else
        % release
        L_GR(n) = ((1-alpha_R)*L_delta(n))+(alpha_R*L_GR_1);
    end
    
    % Update L_A,R to value of previous sample
    L_GR_1 = L_GR(n);
    
    % Convert to linear amplitude scalar
    A(n) = 10^(L_GR(n)/20);
    
    % Apply compression to imput signal
    y(n) = A(n) * x(n);
    
end