%% Summary
%This script prompts the user to input an inner surface temperature for the
%TPS tile.
%Outputs thicknesses for tiles at specific loactions for different
%temperature profiles.
%% Input
prompt = 'Input a desired surface temperature in Celsius ';% User prompt

surfaceTemp = input(prompt);

[thick] = Thickness(surfaceTemp); % Runs function to calculate thicknesses

%% Output

%Temperature profile loactions
filename = ["502 - ","509 - ", "468 - ","597 - ", "480 - ","850 - ",...
    "711 - ","730 - "];

% displays thickness at each position
for a = 1:8
disp (strcat('Location ', filename(a), num2str(thick(a)), ' m'))
end
