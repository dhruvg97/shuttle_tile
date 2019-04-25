function [x, t, u] = shuttle_basic(tmax, nt, xmax, nx, method,doplot)
%% Function for modelling temperature in a space shuttle tile
% 
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
% TPS    - Thermal Protection System
% doplot - true to plot graph; false to suppress graph.
% filename - heat / time distribution 
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle_basic(4000, 501, 0.05, 21, 'forward', true);
%

%% Define Tile materila properties
thermcon = 0.141; % W/(m K)
density  = 352;   %  LI-900
specheat = 1259;  % ~500F
alpha = thermcon/(density * specheat); % factor in differencing methods

%load temperature profile
load 'temp597.mat' timedata tempdata

% Initialise everything.
dt = tmax / (nt-1);
t = (0:nt-1) * dt;
dx = xmax / (nx-1);
x = (0:nx-1) * dx;
u = zeros(nt, nx);
p = alpha * dt / dx^2;

% set initial conditions to 16C throughout.
% Do this for first two timesteps.
u([1 2], :) = 16;

%% Main timestepping loop.
for n = 2:nt - 1
    
    % RHS boundary condition: outer surface. 
    % Use interpolation to get temperature R at time t(n+1).
    R = interp1(timedata, tempdata, t(n+1), 'linear', 'extrap');
    
    %Interative convention
    i=2:nx-1;
    
    % Select method.
    switch method
        case 'forward'
           u(n+1, nx) = R; % RH boundary condtion 
           u(n + 1, 1) = (1 - 2 * p) * u(n , 1) + 2 * p * u(n , 2); % LH Neumann boundary condtion
           
           %Internal points 
           u(n+1,i) = (1 - 2 * p) * u(n , i) + p * (u(n , i-1) + u(n , i+1));
           
        case 'dufort-frankel'
            u(n+1, nx) = R; % Right hand boundary condtion 
            u(n + 1, 1) = ((1 - 2 * p) * u(n - 1, 1) + 4 * p * u(n , 2))/(1 + 2 * p); % LH Neumann boundary condtion
            
            % Internal points 
            u(n + 1, i) = ((1 - 2 * p) * u( n - 1, i) + 2 * p * ( u(n , i - 1) + u(n , i + 1)))/(1 + 2 * p);
        
        case 'backward'
            % matrix arrangement
            b(1) = 1 + 2 * p; % neumann
            c(1) = -2 * p;
            d(1) = u( n , 1);
            a(i) = -p;
            b(i) = 1 + 2 * p;
            c(i) = -p;
            d(i) = u(n , i);
            a(nx) = 0;
            b(nx) = 1 ;
            d(nx) = R ;
            %Solves tdm method
            u(n+1,:) = tdm(a,b,c,d);
        
        case 'crank-nicolson'
            % matrix arrangement
            b(1) = 1 + p; % neumann
            c(1) = -p;
            d(1) = (1 - p) * u(n , 1) + p * u(n , 2);
            a(i) = -p / 2;
            b(i) = 1 + p;
            c(i) = -p / 2;
            d(i) = (p / 2) * u(n , 1 : nx - 2) + (1 - p) * u(n , i) + (p / 2) * u(n , 3 : nx) ;
            a(nx) = 0;
            b(nx) = 1;
            d(nx) =   R ;
            %Solves tdm method
            u(n+1,:) = tdm(a,b,c,d);
        otherwise
            error (['Undefined method: ' method])
            return
    end
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

%% Creates a 3D plot.
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