function[cupsCombined,omega,rpm,t_global,x_centerMetric,y_centerMetric]=Model_parameters(NrBig,NrMed)
% It is choosen to use the kinect to set up a model of the turn table. The
% model function determines the intial position of the cups and the angular 
% velocity of the turntable. Based on the change in time, angular velocity
% and initial position of the cups the position of the cups can be 
% estimated at any given time using another function.

% The input to the function is number of big and medium cups in the order
% and it the outputs the angular velocity of the turn table, ceter of the 
% turntable, a structure which contains the metric postion of the cups and 
% a global time for when the position of the cups are determined.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Take three images and run circle detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up video input and trigger mode

vid = videoinput('mwkinectimaq',1,'RGB_640x480');%rich's laptop uses this
% vid = videoinput('kinect',1,'RGB_640x480');

triggerconfig(vid, 'manual') %The triggermode is set to manual to make the 
                             %image capturing more efficient. This mode 
                             % means that the connection to the kinect is 
                             % opened then the specified number of images is 
                             % taken and at the end the connection is stopped. 
                             % If manual trigger mode is not specified the 
                             % connection is opened and stop for every image. 

%%% Adjustable parameters for the image capturing
itteration_outer = 0; % An itteration counter for the image capturing is intialized
waitImgCap = 0.4; % The time [s] that the code waits between every image 
                  % is captured. 
reduce = 1; % A reduce factor to scale down the images if necessary (the 
            % factor is 1 and therefore does not reduce the image size 
            % because it has been found that reducing the resolution makes 
            % the diffence in cup radius between big and medium cup too small)
            
flag = 0; % flag variable to determine when to exit while loop

% The following while loop is added to make sure that the procedure used to 
% keep track of which cup is which in all three images is successful. 
% The keeping track of the cups is overall based on the assumption that the 
% vector magnitudes between the cups should be the same in every image. 
% Because the images are diffenrent with respect to lighting and cup 
% position (thereby cup perspective) the vector magnitudes can change from 
% image to image and an allowed tollerance is therefore added. If the 
% tolerance is too tight the determinination of which cup is which will 
% return some empty entrances in the structure. If the tolerance is too 
%loss the tracking returns false positives. It has not been possible to 
%find a tolerance that works well in every possible cup order and 
%configuration and it is therefore the following while loop has been added 
%to make sure that the cup tracking works.    
while flag == 0 ;
itteration_outer = itteration_outer + 1;

if itteration_outer >= 2;
    clearvars cupsCombined
end

itteration_inner = 0; % An itteration counter for the image capturing is intialized
max_itteration_inner = 10; % Maximum nummer of itterations are specified
succes = 0; % A succes variable is defined to zero. This is used to ensure 
            % that the image capturing runs until the detected amount of 
            % cups match or is greater that the number given in the order.
all_same = 0; % An all_same varialble is defined to zero. This is used to 
              % ensure that the number and sizes of cups in the three 
              % captured images are the same.

% In the following while loop the image capturing and hough circle
% detection is performed. The loop runs until the amount of medium and big
% cups are the same or greater than what is specified in the order and
% until the number and sizes of detected cups is the same in all three
% images. A maximum number of itterations is added to ensure the loop
% cannot run indefinatly.
while succes == 0 || all_same == 0
    itteration_inner = itteration_inner + 1;

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Capture images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
% Start image acquisition but not logging 
start(vid);
% Start logging data
trigger(vid);


tic % tic starts a timer function that runs in the background
t_start(1,1) = toc; % toc is used to get the current time of the timer 
                    % function before the image is taken.  
                    
img1 = getsnapshot(vid); % The fist image of the turntable is captured

t_stop(1,1) = toc;  % toc is used to get the current time of the timer 
                    % function after the image is taken. 
                    % The time is later used to determine the angular
                    % velocity when the change in angle between the cups 
                    % in each image has ben determined.  
                    
                       
pause(waitImgCap) % A pause is added before the next image is captured to 
                  % ensure a certain change in angular position of the
                  % cups.

t_start(2,1) = toc; % toc is used to get the current time of the timer 
                    % function before the image is taken.  
img2 = getsnapshot(vid); % The second image of the turntable is captured
t_stop(2,1) = toc; % toc is used to get the current time of the timer 
                   % function after the image is taken. 

pause(waitImgCap) % A pause is added before the next image is captured to 
                  % ensure a certain change in angular position of the
                  % cups.

t_start(3,1) = toc; % toc is used to get the current time of the timer 
                    % function before the image is taken. 
img3 = getsnapshot(vid); % The third image of the turntable is captured
t_stop(3,1) = toc; % toc is used to get the current time of the timer 
                   % function after the image is taken. 

t_global = getSeconds; % A t_global is determined using the function 
                       % getSeconds. The function returns the system time in
                       % seconds. The time is later used in a the model of
                       % the turntable.
                   
stop(vid); % The connection to the kinect is terminated

% % The image capturing time is displayed
% disp('Images captured it took')
% t_stop(3,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Change captured images to gray scale and 
%%%%%%% cropped (to make circle detection more efficient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('cameraparams.mat');

img1 = undistortImage(img1,cameraParams);
grayIm1 = rgb2gray(img1); % The first image is change to grayscale
grayIm1Crop = imcrop(grayIm1,[175 75 300 300]); % The first image is cropped
grayIm1Crop = imresize(grayIm1Crop,reduce); % The first image is reduced in 
                                            % size using the reduce factor. 
img2 = undistortImage(img2,cameraParams);
grayIm2 = rgb2gray(img2); % The second image is change to grayscale
grayIm2Crop = imcrop(grayIm2,[175 75 300 300]); % The second image is cropped
grayIm2Crop = imresize(grayIm2Crop,reduce); % The second image is reduced in 
                                            % size using the reduce factor.
img3 = undistortImage(img3,cameraParams);
grayIm3 = rgb2gray(img3); % The third image is change to grayscale
grayIm3Crop = imcrop(grayIm3,[175 75 300 300]); %The third image is cropped
grayIm3Crop = imresize(grayIm3Crop,reduce); % The second image is reduced in 
                                            % size using the reduce factor.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Houghcircle detection and plot of result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Minimun radius in pixels for the circles in the image
min_rad = 36; % Determined iteratively for the given setup

%Maximum radius in pixels for the circles in the image
max_rad = 46; % Determined iteratively for the given setup

%Threshold between 0 and 1
thresh = .42; % Determined iteratively for the given setup

% Delta is the maximal difference between two circles for them to be 
% considered as the same one.
delta = 20; % Determined iteratively for the given setup


%Get x and y positions for the circles in the cropped image. Also the y
%values for the top and the bottom of the circles

%%%%%%%%%%%%%
%%% Image 1
%%%%%%%%%%%%%
t1 = toc; % toc is used to determine the time before circle detection

% The houghcircle detection is performed on the first image
circles1 = houghcircles(grayIm1Crop, min_rad, max_rad,thresh,delta); 

t2 = toc; % toc is used to determine the time before circle detection

% The time to perform houghcircle detection is displayed
% disp('Cicle detection on image 1 took')
% t = t2-t1

r1 = circles1(:,3); % A radius vector for the first image is defined
xcirc1 = circles1(:,1); % A vector containing the x-coordinate for the circle 
                        % center for the first image is defined.
ycirc1 = circles1(:,2); % A vector containing the y-coordinate for the circle 
                        % center for the first image is defined.

ytop1 = ycirc1 - r1; % A vector containing the y-coordinate for the top of 
                     % the circle for the first image is defined. 
ybottom1 = ycirc1 + r1; % A vector containing the y-coordinate for the 
                        % bottom of the circle for the first image is defined. 

% The center, top and bottom points of the detected circles are plotted on 
% top of the cropped image.                        
figure
imshow(grayIm1Crop);
hold on
plot(xcirc1,ycirc1,'*')
plot(xcirc1,ytop1,'.')
plot(xcirc1,ybottom1,'.')

% The detection order of the cups are plotted on top of the image as well
for i = 1:length(r1(:,1))
    info = {strcat('cup ', num2str(i))};
    text(xcirc1(i),ycirc1(i),info);
end

%%%%%%%%%%%%%
%%% Image 2
%%%%%%%%%%%%%
t1 = toc; % toc is used to determine the time before circle detection

% The houghcircle detection is performed on the second image
circles2 = houghcircles(grayIm2Crop, min_rad, max_rad,thresh,delta); 

t2 = toc; % toc is used to determine the time before circle detection

% The time to perform houghcircle detection is displayed
% disp('Cicle detection on image 2 took')
% t = t2-t1

r2 = circles2(:,3); % A radius vector for the second image is defined
xcirc2 = circles2(:,1); % A vector containing the x-coordinate for the circle 
                        % center for the second image is defined.
ycirc2 = circles2(:,2); % A vector containing the y-coordinate for the circle 
                        % center for the second image is defined.
                        
ytop2 = ycirc2 - r2; % A vector containing the y-coordinate for the top of 
                     % the circle for the second image is defined. 
ybottom2 = ycirc2 + r2; % A vector containing the y-coordinate for the 
                        % bottom of the circle for the second image is defined. 

% The center, top and bottom points of the detected circles are plotted on 
% top of the cropped image.                           
figure
imshow(grayIm2Crop);
hold on
plot(xcirc2,ycirc2,'*r')
plot(xcirc2,ytop2,'.r')
plot(xcirc2,ybottom2,'.r')
% The detection order of the cups are plotted on top of the image as well
for i = 1:length(r2(:,1))    
    info = {strcat('cup ', num2str(i))};
    text(xcirc2(i),ycirc2(i),info);
end

%%%%%%%%%%%%%
%%% Image 3
%%%%%%%%%%%%%
t1 = toc; % toc is used to determine the time before circle detection

% The houghcircle detection is performed on the second image
circles3 = houghcircles(grayIm3Crop, min_rad, max_rad,thresh,delta);

t2 = toc; % toc is used to determine the time before circle detection

% The time to perform houghcircle detection is displayed
% disp('Cicle detection on image 3 took')
% t = t2-t1

r3 = circles3(:,3); % A radius vector for the third image is defined
xcirc3 = circles3(:,1); % A vector containing the x-coordinate for the circle 
                        % center for the third image is defined.
ycirc3 = circles3(:,2); % A vector containing the y-coordinate for the circle 
                        % center for the third image is defined.
                        
ytop3 = ycirc3 - r3; % A vector containing the y-coordinate for the top of 
                     % the circle for the third image is defined. 
ybottom3 = ycirc3 + r3; % A vector containing the y-coordinate for the 
                        % bottom of the circle for the second third is defined. 

% The center, top and bottom points of the detected circles are plotted on 
% top of the cropped image.   
figure
imshow(grayIm3Crop);
hold on
plot(xcirc3,ycirc3,'*g')
plot(xcirc3,ytop3,'.g')
plot(xcirc3,ybottom3,'.g')
% The detection order of the cups are plotted on top of the image as well
for i = 1:length(r3(:,1))
    info = {strcat('cup ', num2str(i))};
    text(xcirc3(i),ycirc3(i),info);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if number of cups match expected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_Big = 42; % Minimum radius of big cup in pixels

NrBig1 = 0; NrMed1 = 0; % Initialization of medium and big cup counters 
                        % for the first image 
                        
% The number of detected medium and big cups in the first image is determined                         
for i = 1:length(r1(:,1))
    if  r1(i) >= r_Big  
        NrBig1 = NrBig1 + 1;
    elseif r1(i) < r_Big
        NrMed1 = NrMed1 + 1;
    end 
end

NrBig2 = 0; NrMed2 = 0; % Initialization of medium and big cup counters 
                        % for the second image 
                        
% The number of detected medium and big cups in the second image is determined                           
for i = 1:length(r2(:,1))
    if  r2(i) >= r_Big 
        NrBig2 = NrBig2 + 1;
    elseif r2(i) < r_Big
        NrMed2 = NrMed2 + 1;
    end 
end

NrBig3 = 0; NrMed3 = 0; % Initialization of medium and big cup counters 
                        % for the third image 
                        
% The number of detected medium and big cups in the third image is determined   
for i = 1:length(r3(:,1))
    if  r3(i) >= r_Big 
        NrBig3 = NrBig3 + 1;
    elseif r3(i) < r_Big
        NrMed3 = NrMed3 + 1;
    end 
end

% If the number of detected medium and big cups for all images is equal to 
% or greater than what is in the order the succes is changed to one. This
% is done to make sure that the number of detected cups is at least the
% number given in the order. The reason its not equal to is that if an
% extra cup that is not part of the order is placed on the turntable the
% script is able to continue.
if NrBig1 >= NrBig && NrBig2 >= NrBig && NrBig3 >= NrBig && NrMed1 >= NrMed && ...
        NrMed2 >= NrMed && NrMed3 >= NrMed;
    
    succes = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if number of cups match for all three images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the number of detected cups in all the images is the same the 
% all_same is changed to one. 
if length(xcirc1(:,1)) == length(xcirc2(:,1)) && length(xcirc1(:,1)) == length(xcirc3(:,1))
    all_same = 1;
end

end

disp('vision successful')

%function [ cupsCombined ] = TrackCup( RawCups1, RawCups2, RawCups3 )

%TrackCup take cup locations from consecutive photos, recognise individual
%cups and return a structure array containing the different locations of
%each cup between images
%
%needs to use function getVectors to find the vector magnitude between cups for
%each image
%   
%  cupsCombined is an n by 4 structure array where n=number of cups
%  cupsCombined has fields: radius(cm), pos1(x,y coord), pos2, pos3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%first part for testing only - to construct some example inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Create structures
for i=1:length(xcirc1(:,1))    
    cups1(i).x0 = xcirc1(i,1);
    cups1(i).y0 = ycirc1(i,1);
    cups1(i).a=r1(i,1);     
end

for i=1:length(xcirc2(:,1))    
    cups2(i).x0 = xcirc2(i,1);
    cups2(i).y0 = ycirc2(i,1);
    cups2(i).a=r2(i,1);     
end

for i=1:length(xcirc3(:,1))    
    cups3(i).x0 = xcirc3(i,1);
    cups3(i).y0 = ycirc3(i,1);
    cups3(i).a=r3(i,1);     
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compare relative positions to track cup trajectories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cropOffset=[175,75]; %offset of cropped image from the original image
imageCentre=[321.3,255.75]; % Determined by cameracalibration
imageCentre=[imageCentre(1)-cropOffset(1),imageCentre(2)-cropOffset(2)];
cropScale=reduce;
H=63.5; % Distance from kinect to turntable [cm].
f=(523.61+524.99)/2; % Determined by cameracalibration

%return metric size and location of each cup relative to the centre of the
%image
cups1=metricLocation(cups1, cropOffset, cropScale, H, f);
cups2=metricLocation(cups2, cropOffset, cropScale, H, f);
cups3=metricLocation(cups3, cropOffset, cropScale, H, f);
%compare the relative vector magnitudes and directions between each of the images. if two
%sets of cup data share the same diameter relative distances, and relative angles to
%neighbors, these are the same cup.

numcups=size(cups1,2);

%determine metric location of cups relative to the corner of the cropped
%image
imageMetric=(H/f)*imageCentre;
for i=1:numcups
    
    cups1(i).mPos1origin = cups1(i).MetricPos + imageMetric;
    cups2(i).mPos2origin = cups2(i).MetricPos + imageMetric;
    cups3(i).mPos3origin = cups3(i).MetricPos + imageMetric;   
end


%get the vector magnitude and angles for each of the images
cups1=Vectors_2(cups1);
cups2=Vectors_2(cups2);
cups3=Vectors_2(cups3);


dist_tol = 1.2;
angle_tol = 0.4;
%compare cup sizes and the vector magnitude and direction information for
%all cups over three images to determine which cups are the same over the
%three. this information can be used to measure distance travelled and
%speed of rotation. 
for i=1:numcups
    for j=1:numcups
        for k=1:numcups
            %retrieve vector angle and magniture information
            vectorMags1=cups1(i).vectorMags;
            vectorAngs1=cups1(i).vectorAngs;

            vectorMags2=cups2(j).vectorMags;
            vectorAngs2=cups2(j).vectorAngs;

            vectorMags3=cups3(k).vectorMags;
            vectorAngs3=cups3(k).vectorAngs;
            
            %logical operations to compare cup size, angle and direction
            %information for each cup to determine if their respective
            %values fit within a certain tolerance value. 
            samecup1=(cups1(i).metricRadius == cups2(j).metricRadius);
            dist1=min(abs(vectorMags1 - vectorMags2) < dist_tol);
            angle1=min(abs(vectorAngs1 - vectorAngs2) < angle_tol);
            
            samecup2=(cups2(j).metricRadius == cups3(k).metricRadius);
            dist2=min(abs(vectorMags2 - vectorMags3) < dist_tol) ;
            angle2=min(abs(vectorAngs2 - vectorAngs3) < angle_tol);
            
            if samecup1==1 && dist1==1  && angle1==1   && samecup2==1  ...
                    && dist2==1  && angle2==1  
                    
                    
                    pos1=[cups1(i).x0, cups1(i).y0];
                    pos2=[cups2(j).x0, cups2(j).y0];
                    pos3=[cups3(k).x0, cups3(k).y0];
                    %construct new array cupsCombined which contains
                    %information for the three locations of each cup over
                    %the three images. 
                   
                    cupsCombined(i).Radius=cups1(i).metricRadius;
                    cupsCombined(i).Pos1=pos1;
                    cupsCombined(i).Pos2=pos2;
                    cupsCombined(i).Pos3=pos3;
                    cupsCombined(i).mPos1=cups1(i).MetricPos;
                    cupsCombined(i).mPos2=cups2(j).MetricPos;
                    cupsCombined(i).mPos3=cups3(k).MetricPos;
                    
            else 
                    
                
            end
        end %for k
    end %for j          
end %for i 

succes3 = 0;
if size(cups1,2) == size(cupsCombined,2)
    succes3 =1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if cupsCombined is successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the following two succes criterias are checked to ensure that the 
%determination of which cup is which in every image is successful. 

% The first criteria is to check if any entrances in the resulting
% cupsCombined structure is undefined (this results in [] which is due to a
% tollerance that is too tight).
if succes3 ==1;
succes1 = 1;
for i = 1:numcups 
    if sum(size(cupsCombined(i).Radius)) == 0;
        succes1 = 0;
        disp('Zero entries in cupscombined')
    end
end

% The second criteria is only checked if the first one is succesful. The 
% second criteria checks if any of the entrances in the resulting 
% cupsCombined structure are identical which is not allowed (this is a due 
% to the tolerance being too loose).
if succes1 == 1;
    
    k = 1;
    for i = 1:numcups
        stacked_array(k:k+2,1:2) = [cupsCombined(i).Pos1 ; ...
            cupsCombined(i).Pos2 ; cupsCombined(i).Pos3]; % The position of 
                                                          % the cups are 
                                                          % stacked into an 
                                                          % array to ease 
                                                          % comparison.
    k = k + 3;
    end

    % All of the entries are compared to each other to check if any of them
    % are identical which is not allowed.
    succes2 = 1;
    for i = 1:length(stacked_array(:,1))
        for j = 1:length(stacked_array(:,1))
        
            if i ~= j
            pos1 = stacked_array(i,1:2);
            pos2 = stacked_array(j,1:2);
                if pos1 == pos2
               succes2 = 0; 
               disp('Identical entries in cupscombined')
                end
        
            end
        
        end
    end
else
    succes2 = 0;  
end
else 
    succes1 = 0;
    succes2 = 0;
end
% If both criterias are successful the flag is changed to 1 and the while
% loop is thereby exited.
if succes2 == 1 && succes1 == 1 
    flag = 1;
end

end

%plot the results
figure
imshow(grayIm1Crop);
hold on
for i=1:numcups
    
    pos1=cupsCombined(i).Pos1; %plotted in blue
    pos2=cupsCombined(i).Pos2; %plotted in green
    pos3=cupsCombined(i).Pos3; %plotted in red
    
    plot(pos1(1), pos1(2), 'bo'), hold on, axis on
    plot(pos2(1), pos2(2), 'go')
    plot(pos3(1), pos3(2), 'ro')
end

imageMetric=(H/f)*imageCentre;
for i=1:numcups   
    cupsCombined(i).mPos1origin = cupsCombined(i).mPos1 + imageMetric;
    cupsCombined(i).mPos2origin = cupsCombined(i).mPos2 + imageMetric;
    cupsCombined(i).mPos3origin = cupsCombined(i).mPos3 + imageMetric;   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculation of turntable center using least square optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A least square optimisation is performed on the three images/positions 
% for each of the detected cups. This is done to find the optimal circel 
% that matches the  three cup positions the best. Thereby the point around 
% which each cup rotates is  estimated. This point should in theory be the 
% same for all the detected cups which is the center of the turntable. 
for i = 1 : numcups
P_cup_i = [cupsCombined(i).Pos1
            cupsCombined(i).Pos2
            cupsCombined(i).Pos3];
[r_estimated(i),a(i),b(i)] = Circle_func(P_cup_i);
end

% The three cup positions together with the estimated center of rotation is
% plotted for each of the detected cups.
figure
imshow(grayIm1Crop);
hold on
for i = 1 : length(xcirc1(:,1))
P_cup = [cupsCombined(i).Pos1
           cupsCombined(i).Pos2
           cupsCombined(i).Pos3];    
 
if i == 1       
plot(P_cup(:,1),P_cup(:,2),'xb')       
plot(a(i),b(i),'ob')
elseif i == 2
plot(P_cup(:,1),P_cup(:,2),'xy')       
plot(a(i),b(i),'oy')
elseif i == 3
plot(P_cup(:,1),P_cup(:,2),'xg')       
plot(a(i),b(i),'og') 
elseif i == 4
plot(P_cup(:,1),P_cup(:,2),'xk')       
plot(a(i),b(i),'ok')
elseif i == 5
plot(P_cup(:,1),P_cup(:,2),'xr')       
plot(a(i),b(i),'or')
end       
       
end

% Because the optimasation only is based on three cup positions and most
% likely because of the changing perspective in the image the estimated 
% center of rotation for each of the cups is not exactly the same. The 
% turntable center is estimated as the average of the calculated points.   
x_center = sum(a(1,:))/length(a(1,:));
y_center = sum(b(1,:))/length(b(1,:));
plot(x_center,y_center,'*c')

% The center of the turntable is calculated in metric space
x_centerMetric = (H/f)*(x_center-imageCentre(1));
y_centerMetric = (H/f)*(y_center-imageCentre(2));

x_centerMetric=x_centerMetric+imageMetric(1);
y_centerMetric=y_centerMetric+imageMetric(2);


% The metric position of the cups are plotted together with the turn table
% in metric space. 
figure
hold on
axis equal
for i = 1:length(xcirc1(:,1)) 
cups1pos = cups1(i).MetricPos;  
cups2pos = cups2(i).MetricPos;  
cups3pos = cups3(i).MetricPos;  
plot(cups1pos(1), cups1pos(2),'*')
plot(cups2pos(1), cups2pos(2),'*r')
plot(cups3pos(1), cups3pos(2),'*g')
end
a=23/2; % Metric radius of turntable [cm]. 

t = linspace(0,2*pi,1000);  
x = x_centerMetric + a * cos(t) ;
y = y_centerMetric + a * sin(t) ;
plot(x,y, 'color', 'black')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Calculation of angular velocity of turn table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To be able to calculate the angular velocity of the turn table a set of
% vectors going from the turntable center to the three cup positions is
% calculated for each of the detected cups. The calculated vectors are
% plotted on top of the first image.
figure
imshow(grayIm1Crop);
hold on
for i = 1 : numcups % The for loop is run for each of the detected cups.
    
   output1 = cupsCombined(i).Pos1; 
   X_pos1 = output1(1); % The x-coordinate of the cup position in the first 
                        % image is defined.
   Y_pos1 = output1(2); % The y-coordinate of the cup position in the first 
                        % image is defined.
   vector1 = [X_pos1 Y_pos1] - [x_center y_center]; % A vector going form 
                                                    % the turn table center
                                                    % to the cup position 
                                                    % in the first image is
                                                    % calculated.
   
   output2 = cupsCombined(i).Pos2; 
   X_pos2 = output2(1); % The x-coordinate of the cup position in the second 
                        % image is defined.
   Y_pos2 = output2(2); % The y-coordinate of the cup position in the second 
                        % image is defined.
   vector2 = [X_pos2 Y_pos2] - [x_center y_center]; % A vector going form 
                                                    % the turn table center
                                                    % to the cup position 
                                                    % in the second image is
                                                    % calculated.
   
   output3 = cupsCombined(i).Pos3; 
   X_pos3 = output3(1); % The x-coordinate of the cup position in the third 
                        % image is defined.
   Y_pos3 = output3(2); % The y-coordinate of the cup position in the third 
                        % image is defined.
   vector3 = [X_pos3 Y_pos3] - [x_center y_center]; % A vector going form 
                                                    % the turn table center
                                                    % to the cup position 
                                                    % in the third image is
                                                    % calculated.
   
   % All the three calculated vectors are arranged in an array and 
   % subsequently inserted into a structure array. 
   vectors = [vector1;vector2;vector3];
   cupsCombined(i).Vectors = vectors;     

% The vectors are plotted on top of the first image with different colors
% for each detected cup.
if i == 1       
plot([x_center X_pos1],[y_center Y_pos1],'b')
plot([x_center X_pos2],[y_center Y_pos2],'b')  
plot([x_center X_pos3],[y_center Y_pos3],'b')  

elseif i == 2
plot([x_center X_pos1],[y_center Y_pos1],'y')
plot([x_center X_pos2],[y_center Y_pos2],'y')  
plot([x_center X_pos3],[y_center Y_pos3],'y')       

elseif i == 3
plot([x_center X_pos1],[y_center Y_pos1],'g')
plot([x_center X_pos2],[y_center Y_pos2],'g')  
plot([x_center X_pos3],[y_center Y_pos3],'g')  

elseif i == 4
plot([x_center X_pos1],[y_center Y_pos1],'k')
plot([x_center X_pos2],[y_center Y_pos2],'k')  
plot([x_center X_pos3],[y_center Y_pos3],'k') 

elseif i == 5
plot([x_center X_pos1],[y_center Y_pos1],'r')
plot([x_center X_pos2],[y_center Y_pos2],'r')  
plot([x_center X_pos3],[y_center Y_pos3],'r')   
end

end

% The angle between the cup vector for the first image and the second image
% is calculated. And the angle between the cup vector for the second and
% the third image is calculated. This is done for each of the detected
% cups.
for i = 1 : numcups   
    vectors = cupsCombined(i).Vectors; % The calculated vectors are read 
                                       % from the structure array.
    vector1 = vectors(1,1:2); % Cup postion vector for cup i in the first 
                              % image is defined.
    vector2 = vectors(2,1:2); % Cup postion vector for cup i in the second 
                              % image is defined.
    vector3 = vectors(3,1:2); % Cup postion vector for cup i in the third 
                              % image is defined.
    
    % The angle between the cup position vector in the first and second
    % image is calculated.
    theta_matrix(1,i) = acos((dot(vector1,vector2))/(norm(vector1)*norm(vector2)));
    
    % The angle between the cup position vector in the second and third
    % image is calculated.
    theta_matrix(2,i) = acos((dot(vector2,vector3))/(norm(vector2)*norm(vector3)));
end

% Based on the calculated angles between the cup position vectors and the
% time at which each image is captured the angular velocity is calculated.
% Initially the change in angle over time (angular velocity) between each
% vector for each cup is calculated.
for i = 1 : numcups   
    delta_t1 = t_stop(2,1) - t_stop(1,1); % The time between capturing the 
                                          % first image and the second image 
                                          % is calculated. 
    delta_t2 = t_stop(3,1) - t_stop(2,1); % The time between capturing the 
                                          % second image and the third image 
                                          % is calculated. 
    
    omega_matrix(1,i) = theta_matrix(1,i)/delta_t1; % The angular velocity between 
                                             % the first and the second 
                                             % image is calculated for cup i.
    omega_matrix(2,i) = theta_matrix(2,i)/delta_t2; % The angular velocity between 
                                             % the second and the third 
                                             % image is calculated for cup i.
end

% The angular velocity is calcultated as the average of all the calculated
% angular velocities between each vector.
% omega = sum(sum(omega_matrix))/(length(omega_matrix(1,:))*2);
omega = sum(omega_matrix(2,:))/(length(omega_matrix(1,:)));

% The angular velocity calculated in radians/second is converted to 
% revolutions per minute (rpm). 
rpm = omega*60/(2*pi);

% The posistion of the cups in the third image are converted to polar
% coordinates and added to the structure. This is used lated to estimate
% the position of the cups at a given time. It is the third image because
% the time_global is related to the third image. 
centre_metric=[x_centerMetric, y_centerMetric];
for i=1:numcups
    poscentre=cupsCombined(i).mPos3origin-centre_metric;
    cupsCombined(i).poscentre = poscentre;
    [theta,r]=cart2pol(poscentre(1),poscentre(2) );
    cupsCombined(i).Theta_R=[theta,r];
end


end