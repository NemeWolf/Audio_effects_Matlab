function [y,G]=fade(x,fs,n0,n1,shape,type, beta, log_g)
%=================================================
% Fade in - out
%=================================================
% Input
% x: input signal
% n0: initial fade
% n1: end fade
% shape: Fade shape - ('exp','log','s', default='exp')
% type: Fade type - ('in','out', default='in')
% beta: Coeficient of exponential fade - (default=1)
% log_g: Gain of log fade - (default=-10)
%=================================================
% Output
% y: output signal
% G: Fade gain
%=================================================
%% Default values ==================================================================================
if nargin < 5 || isempty(shape)
    shape = 'exp';
end
if nargin < 6 || isempty(type)
    type = 'in';
end
if nargin < 7 || isempty(beta)
    beta = 1;
end
if nargin < 8 || isempty(log_g)
    log_g = -10;
end    
%% Validations =====================================================================================
if ~ischar(shape) && ~isstring(shape)
    error('The "shape" argument must be a string or character array.');
end

if ~ischar(type) && ~isstring(type)
    error('The "type" argument must be a string or character array.');
end
%% Initial values ==================================================================================
N = length(x);
n = 0:(N-1);
%% Select fade =====================================================================================
% Fade Exp 
if strcmp(shape, 'exp') && strcmp(type, 'in')
    G = 1 - ((n1-n)/(n1-n0)).^beta;
elseif strcmp(shape, 'exp') && strcmp(type, 'out')    
    G = 1 - ((n-n0)/(n1-n0)).^beta;
% Fade Log     
elseif strcmp(shape, 'log') && strcmp(type, 'in')     
    G = 10.^((log_g/20)*(n1-n)/(n1-n0));    
elseif strcmp(shape, 'log') && strcmp(type, 'out')
    G = 10.^((log_g/20)*(n-n0)/(n1-n0));
% Fade S Shape     
elseif strcmp(shape, 's') && strcmp(type, 'in')     
    G = -0.5*(cos(pi*(n-n0)/(n1-n0))-1);   
elseif strcmp(shape, 's') && strcmp(type, 'out')
    G = 0.5*(cos(pi*(n-n0)/(n1-n0))+1);
end
%% Fade correction =================================================================================
for n=1:N
    if n>n1
        if strcmp(type, 'in')
        G(n)=1;
        elseif strcmp(type, 'out')
        G(n)=0;
        end
    end
end    
%% Apply fade to signal ============================================================================
y = x.*G;