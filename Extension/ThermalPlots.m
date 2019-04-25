% Plot the data for thermal conductivity and specific heat capacity

%% Intialise parameters

%Load k and Cp data
load ('ThermalProp.mat', 'TempData');

%convert to arrays
temp = table2array(TempData(:,1));
k = table2array(TempData(:,3));
Cp = table2array(TempData(:,2));

temprange = -20:10:1600;

% Calculates linear function for thermal condcutivity W/mK
km = polyfit(temp,k,1); 
thermcon = polyval(km,temprange); % finds k for a chosen input temperature

%Calculates quadratic function for specific heat capacity J/ kg K
Cpm = polyfit(temp,Cp,4);
specheat = polyval(Cpm,temprange);

%% Plots values for data and approximations

% thermal conductivity k
figure (1)
plot(temp,k,'*')
hold on
plot (temprange,thermcon,'-')
hold off
grid on
grid minor

xlabel('Temperature /^{o}C')
ylabel('Thermal Conductivity (k) / W/mK')
legend('Experimental Data', 'Linear Approximation')

% Specfic heat capacity
figure (2)
plot(temp,Cp,'*')
hold on
plot (temprange,specheat,'-')
hold off
grid on
grid minor

xlabel('Temperature /^{o}C')
ylabel('Specific Heat Capcity (Cp) / J/kgK')
legend('Experimental Data', 'Quartic Approximation')
