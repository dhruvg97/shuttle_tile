function [timedata,tempdata] = scanFunc(filename)
%% scanFunc
% Outputs right-hand boundary data for different temperature profiles
%Inputs: filename = different temp profiles
%Outputs: time data and temp data

%% Convert Image to array 
img=imread([filename '.jpg']);

[vert,horiz,~]=size(img);% size of image matrix
a = zeros(vert,horiz);
indexvec = zeros(1,horiz);

%% Find plot axes

%scan image to find X- axis origin point 
imgcut = img(:,100,1)<10 & img(:,100,2)<10 & img(:,100,3)<10;
blackvals = find(imgcut);
xorigin = blackvals(1);

%scan image to find y- axis origin point 
imgcut2 = img(100,:,1)<150 & img(100,:,2)<150 & img(118,:,3)<150;
blackvals2 = find(imgcut2);
yorigin = blackvals2(1);

%scan image to find y-axis limits
imgcut3 = img(:,yorigin + 2,1)<10 & img(:,yorigin + 2,2)<10 & img(:,yorigin + 2,3)<10;
blackvals3 = find(imgcut3);
ytoplimit = blackvals3(1); %43
ybotlimit = blackvals3(end); % 134

%scan image to find x-axis limits
imgcut4 = img(xorigin-2,:,1)<150 & img(xorigin-2,:,2)<150 & img(xorigin-2,:,3)<150;
blackvals4 = find(imgcut4);
xtoplimit = blackvals4(end); %324
xbotlimit = blackvals4(1); %50

%% Take image slices along the horizontal axis

for m =1:horiz % loops through horizontal number of pixel
    
    a(:,m) = img(:,m,1)>150 & img(:,m,2)<150 & img(:,m,3)<150; % finds red pixels in the image
    b = find (a(:,m));
    indexvec(m) = mean(b); % takes avergae of pixels 
    
end
%% scale data correctly
datarange = indexvec(xbotlimit : xtoplimit);
datapoints = length(datarange);
timestep = 2000/length(datarange);
timedata = 0:timestep:4000-1; % scaled time data
tempdata = zeros(1,length(timedata));

% convert scale and axes
grad = (2000)/(ytoplimit - ybotlimit); % gradient of slope
yinter = -(grad * ybotlimit ); % y intercept

% loops through all the pixel values - converts to celcius
for p = 1:datapoints
        tempdata(p) = datarange(p)*grad + yinter; % tempdata out as y variable
end
hold off

tempdata = (5/9)*(tempdata-32);  %farenheight to celcius conversion

k = find (isnan(tempdata));
tempdata(k) = 0;

endAverage = (tempdata(datapoints - 2) + tempdata(datapoints - 10) + tempdata(datapoints - 20))/3; 

tempdata(datapoints:end) = endAverage;

%save data to .mat file with same name as image file
save(filename, 'timedata', 'tempdata')
end

