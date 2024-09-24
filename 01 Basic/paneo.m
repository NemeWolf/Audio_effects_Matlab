function [y, g_L, g_R]=paneo(x,alpha,type)
%=================================================
% Panning
%=================================================
% Input
% x: input signal
% alpha: precedence factor
% type: type of panning (default=linear) (linear - cuadratic - sinusoid - tangent)
%=================================================
% Output
% y: signal panned
%=================================================

%% Default values ==================================================================================
if nargin < 4 || isempty(type)
    shape = 'linear';
end
%% Validations =====================================================================================
if ~ischar(shape) && ~isstring(type)
    error('The "type" argument must be a string or character array.');
end
%% Initial values ==================================================================================
% Stereophonic system
x_L = x(:,1)';
x_R = x(:,2)';
%% Apply ===========================================================================================
% Linear
if strcmp(type,'linear')
    g_L=1-alpha;
    g_R=alpha;
% Cuadratic
elseif strcmp(type,'cuadratic')
    g_L=sqrt(1-alpha);
    g_R=sqrt(alpha);
% Sinusoid
elseif strcmp(type,'sinusoid')
    g_L=sin((1-alpha)*pi/2);
    g_R=sin(alpha*pi/2);
% Tangent
elseif strcmp(type,'tangent')
    g_L=tan((1-alpha)*pi/4);
    g_R=tan(alpha*pi/4);
end

y_L=x_L*g_L;
y_R=x_R*g_R;

y = [y_L(:) y_R(:)];

