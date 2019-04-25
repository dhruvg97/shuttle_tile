function [thick] = Thickness(surfaceTemp)
%% Thickness 
% Takes a maximum inner surface temp
% outputs thickness of tiles for different loactions

%Input: surfaceTemp = temperature in Celsius
%Outputs: thick = array of thickness 

% Specifies different locations on bottom of Space Shuttle
filename = ["temp502","temp509", "temp468","temp597", "temp480","temp850",...
    "temp711","temp730"];

thick= zeros(1,8);

%Loops through shooting method for each temperature profile
for n = 1:8
    thick(n) = shuttleShooting(surfaceTemp, char(filename(n)));
  
end

end