% This script plots the inner surface temperature for different spatial
% steps nx used to assess stability and accuracy

%% Intialise parameters

i=0;  
nt = 501; %time steps
thick = 0.05; %tile tickness
tmax = 4000; %time range

%% Loop to find inner surface temps
for nx = 5:5:60
    i=i+1;
    nx1(i) = nx; 
    disp (['nx = ' num2str(nx)]) %displays number of spatial steps
    
   % Runs for Forward Differencing
    [~, ~, u] = shuttle_basic(tmax, nt, thick, nx, 'forward', false); 
    uf(i) = u(end, 1); 
    
    %Runs for backward differencing
    [~, ~, u] = shuttle_basic(tmax, nt, thick, nx, 'backward', false); 
    ub(i) = u(end, 1);
    
    % Runs for dufort-frankel
    [~, ~, u] = shuttle_basic(tmax, nt, thick, nx, 'dufort-frankel', false); 
    ud(i) = u(end, 1);
    
    % Runs for crank-nicolson
    [~, ~, u] = shuttle_basic(tmax, nt, thick, nx, 'crank-nicolson', false); 
    uc(i) = u(end, 1);
    
end 

%% Plots graph of temp vs nx

plot(nx1, [uf; ub; ud; uc],'LineWidth',1.25) 
ylim([155 165]) 
grid on
grid minor

xlabel('Number of spatial steps')
ylabel('Inner surface temperature /^{o}C')

% creates highlighted error range
x = [0 60 60 0];
y = [161.2017 161.2017 159.5978 159.5978];

patch(x,y,'k', 'FaceAlpha',0.2, 'EdgeColor','none')
legend ('Forward', 'Backward','Dufort-Frankel', 'Crank-Nicolson','\pm 0.5%' )