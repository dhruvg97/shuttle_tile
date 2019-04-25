%This Function plots the inner surface temperature for different tile
%thicknesses using crank-nicolson

%% Intialise Parameters
n = 1;
a = 0.05: 0.01: 0.1; % tickness tange
    
tempsF = zeros (length(a),501);

%% Loops through for different thicknesses 
for a = 0.03: 0.01: 0.1
    
    % Runs temperature distribution 
    [x, t, u] = shuttle_basic(4000, 501, a, 21, 'crank-nicolson', false);

    tempsF(n,:) = u(:,1); % finds inner surface temperature
    
    %Plots inner surface temperature
    figure(2)
    plot(t, tempsF(n,:))
    hold on
    
    n= n +1;
end

%% Plot formatting
 grid on
 grid minor
 
 title('Plot showing the inner surface temp for different tile thicknesses')
 xlabel('Time (s)')
 ylabel('Temperature (degrees)')
 
 legend('0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.10')
 