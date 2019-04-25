% This script plots the inner surface temperature for different time step sizes
% dt used to assess stability and accuracy

%% Intialise Parameters
i=0; 
nx = 21; % number of spatial steps
thick = 0.05; % tile tickness 
tmax = 4000;  %time range

%% Loop to find inner surface temps
for nt = 31:5:501
    i=i+1; 
    dt(i) = tmax/(nt-1);
    steps(i) = nt;
    disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) %displays number of number and size of time steps
   
    
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

%% Plots graph of temp vs dt

plot(dt, [uf; ub; ud; uc],'LineWidth',1.25) 
ylim([158 162]) 
grid on
grid minor
xlabel('Time step size (dt) /s')
ylabel('Inner surface temperature /^{o}C')
hold on

% creates highlighted error range
x = [0 4000/31 4000/31 0];
y = [161.2017 161.2017 159.5978 159.5978];
%c = [0.7,0.7,0.7];
patch(x,y,'k', 'FaceAlpha',0.2, 'EdgeColor','none')
legend ('Forward', 'Backward','Dufort-Frankel', 'Crank-Nicolson','\pm 0.5%')
