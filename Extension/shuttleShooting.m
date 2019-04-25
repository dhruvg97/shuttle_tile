function [tileThick] = shuttleShooting(surfaceTemp,filename)
%% shuttleShooting
% Runs the shooting method to find the tile tickness for a specific max
% inner surface tempeature

%Inputs: surfaceTemp = temperature in degrees, filname = temperature
%profile file eg. 'temp468'

%Output: thick = thickness /m.

doplot = false;% supresses plot

error = []; %error array
guess = [0.03,0.1]; % input guess arrays for thickness

%% Arbitraray Guess 1

[~,~,u] = shuttle_ext( guess(1), doplot, filename); % Finds temperature distribution
error(1) =  max(u(:, 1)) - surfaceTemp; % calcualtes error from guess

%% Arbitrary Guess 2

[~,~,u] = shuttle_ext(guess(2), doplot, filename); % Finds temperature distribution
error(2) = max(u(:, 1)) - surfaceTemp; % calcualtes error from guess


%% Compute next guess

while abs(error(end)) > 0.01 % error less than 0.01 celcius
    
    %Calculates next guess
    guess = [guess, (guess(end) - error(end) * ((guess(end) - guess(end-1))/(error(end) - error(end-1))))];
    [~,~,u] = shuttle_ext(guess(end), doplot, filename);
    
    %error between surfaceTemp and new guess
    error = [error, max(u(:, 1)) - surfaceTemp];
end

%Displays answer to 4 dp
digitsOld = digits(4);
tileThick = vpa(guess(end));
    

end

