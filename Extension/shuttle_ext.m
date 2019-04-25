function [x, t, u] = shuttle_ext(xmax, doplot,filename)
%% Function for modelling temperature in a space shuttle tile
% 
%
% Input arguments:
% xmax   - total thickness
% doplot - true to plot graph; false to suppress graph.
% filename - temp / time distribution 
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle_ext(0.05, true, 'temp597');
%

%% Set tile properties
% Loads surface temperature data from file.

load([filename '.mat'], 'timedata', 'tempdata')

% Initialise everything.
tmax = 4000;
nt = 71; % Optimised time steps
nx = 31; %Optimised spatial steps
dt = tmax / (nt-1);
t = (0:nt-1) * dt;
dx = xmax / (nx-1);
x = (0:nx-1) * dx;
u = zeros(nt, nx);

% set initial conditions to 16C throughout.
% Do this for first two timesteps.
u([1 2], :) = 16;

%% Main timestepping loop.
%Uses crank nicolson method

for n = 2:nt - 1
    
    % RHS boundary condition: outer surface. 
    % Use interpolation to get temperature R at time t(n+1).
    R = interp1(timedata, tempdata, t(n+1), 'linear', 'extrap');
    
    %Interative convention
    i=2:nx-1;
            % matrix arrangement
            %Neumann boundary conditions
            b(1) = 1 + P(u(n , 1),xmax); 
            c(1) = -P(u(n , 1),xmax);
            d(1) = (1 - P(u(n , 1),xmax)) * u(n , 1) + P(u(n , 1),xmax) * u(n , 2);
            a(i) = -P(u(n , i),xmax) / 2;
            b(i) = 1 + P(u(n , i),xmax);
            c(i) = -P(u(n , i),xmax) / 2;
            d(i) = (P(u(n , 1:nx-2),xmax)/ 2) * u(n , 1 : nx - 2) + (1 - P(u(n , i),xmax)) * u(n , i) + (P(u(n , 3:nx),xmax) / 2) * u(n , 3 : nx) ;
            a(nx) = 0;
            b(nx) = 1;
            d(nx) =   R ; % Right hand condtion
            
            %Solves tdm method
            u(n+1,:) = tdm(a,b,c,d);
end


%% Tri-diagonal matrix solution 
function x = tdm(a,b,c,d)
m = length(b);

% Eliminate a terms
for j = 2:m
    factor = a(j) / b(j-1);
    b(j) = b(j) - factor * c(j-1);
    d(j) = d(j) - factor * d(j-1);
end

x(m) = d(m) / b(m);

% Loop backwards to find other x values by back-substitution
for h = m-1:-1:1
    x(h) = (d(h) - c(h) * x(h+1)) / b(h);
end

end

%% Plots 3D graph
if doplot
    
    % 3D plot of temperature through tile
    figure(3)
    surf(x,t,u)
    shading interp
     %label the axes
    xlabel('\itx\rm - m')
    ylabel('\itt\rm - s')
    zlabel('\itu\rm - deg C')
    

end
% End of shuttle function
end   