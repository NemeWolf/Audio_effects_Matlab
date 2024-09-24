function y=phaser_linear_interp(x,M)
%=================================================
% Phaser with linear interpolation
%=================================================
%Input
%x: input signal
%M: delay modulation
%=================================================
%Output
%y: output signal
%=================================================

N = length(x);
g_phaser=0.5;   % all pass coeficient (between 0 and 1)

%prelocating
Mt = zeros(1,N);
eta = zeros(1,N);
y=zeros(1,N);

for n = (1:N)
    
    Mt(n) = floor(M(n)); 
    
    if  (n - Mt(n) - 1) > 0 && n - Mt(n) - 1 > 0
        
        eta(n) = M(n)-Mt(n);        
         
        % linear interpolation
        x_0 = x(n - Mt(n) );
        x_1 = x(n - Mt(n) - 1 );

        x_interp = (1 - eta(n) ) * x_0 + eta(n) * x_1;
        
        y_0 = y(n - Mt(n) ); 
        y_1 = y(n - Mt(n) - 1 ); 

        y_interp = (1 - eta(n)) * y_0 + eta(n) * y_1;
        
        % Apply phaser (APF)
        y(n)  = -g_phaser*x(n) + x_interp + g_phaser*y_interp;
        
        % Direct implementation
        %y(n)  = -g_phaser*x(n) + x(n - Mt(n) ) + g_phaser*y(n - Mt(n));

    else
        y(n) = 0;       
    end
    
end