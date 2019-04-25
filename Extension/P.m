function [thermalDiff] = P(u,xmax)
%% P Summary 
%   This function calculates the thermal diffusivity for a specific
%   temperature for AETB-12
% Inputs: u = temperature, xmax = tile thickness
% Outputs: thermalDiff = thermal diffusivity

%Load k and Cp data
load ('ThermalProp.mat', 'TempData');

%convert to arrays
temp = table2array(TempData(:,1));
k = table2array(TempData(:,3));
Cp = table2array(TempData(:,2));

%% Initialise parameters

density  = 187.8;   % AETB-12 kg/m^3
tmax = 4000;
nt = 71;
dt = tmax / (nt-1);
nx = 31;
dx = xmax / (nx-1);

% Calculates linear function for thermal condcutivity W/mK
km = polyfit(temp,k,1); 
thermcon = polyval(km,u); % finds k for a chosen input temperature

warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
% Calculates quartic function for specific heat capacity J/ kg K
Cpm = polyfit(temp,Cp,4);
specheat = polyval(Cpm,u);



% calcualtions for the thermal diffusivity
alpha = thermcon/(density * specheat);
       
thermalDiff = alpha * dt / dx^2;


end

