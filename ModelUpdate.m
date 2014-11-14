function[cupsCombinedNew,t_globalNew]=ModelUpdate(NrBig,NrMed,cupsCombined,x_centerMetric,y_centerMetric,t_global )

% This function is used to update the position of the cups when it is called.

% The input to the function is the number of big and medium cups in the
% given order, the metric position of the center of the turn table, the
% time at which the model was derived at the first time and the structure
% containing the position of the cups. The function then outputs and
% updated structure in which the position of the cups have been updated and
% it outputs the time at which the new position of the cups were determined. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Take new images and run circle detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up video input and trigger mode
vid = videoinput('mwkinectimaq',1,'RGB_640x480'); %rich's laptop uses this
%vid = videoinput('kinect',1,'RGB_640x480');

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

while succes == 0 && (itteration_inner < max_itteration_inner) || all_same == 0
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
                    
imgNew = getsnapshot(vid); % An image of the turntable is captured

t_stop(1,1) = toc;  % toc is used to get the current time of the timer 
                    % function after the image is taken. 
                    % The time is later used to determine the angular
                    % velocity when the change in angle between the cups 
                    % in each image has ben determined.  
                    
t_globalNew = getSeconds; % A new t_global is determined using the function 
                       % getSeconds.The function returns the system time in
                       % seconds. The time is later used in a the model of
                       % the turntable.
                       
stop(vid); % The connection to the kinect is terminated

% The image capturing time is displayed
disp('Images captured it took')
t_stop(1,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Change captured images to gray scale and 
%%%%%%% cropped (to make circle detection more efficient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('cameraparams.mat');

imgNew = undistortImage(imgNew,cameraParams); % The image is undistorted
grayImNew = rgb2gray(imgNew); % The first image is change to grayscale
grayImNewCrop = imcrop(grayImNew,[175 75 300 300]); % The first image is cropped
grayImNewCrop = imresize(grayImNewCrop,reduce); % The first image is reduced in 
                                            % size using the reduce factor. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Houghcircle detection and plot of result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Minimun radius in pixels for the circles in the image
min_rad = 34; % Determined iteratively for the given setup

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
%%% Image New
%%%%%%%%%%%%%
t1 = toc; % toc is used to determine the time before circle detection

% The houghcircle detection is performed on the first image
circlesNew = houghcircles(grayImNewCrop, min_rad, max_rad,thresh,delta); 

t2 = toc; % toc is used to determine the time before circle detection

% The time to perform houghcircle detection is displayed
disp('Cicle detection on image 1 took')
t = t2-t1

rNew = circlesNew(:,3); % A radius vector for the first image is defined
xcircNew = circlesNew(:,1); % A vector containing the x-coordinate for the circle 
                        % center for the first image is defined.
ycircNew = circlesNew(:,2); % A vector containing the y-coordinate for the circle 
                        % center for the first image is defined.

ytopNew = ycircNew - rNew; % A vector containing the y-coordinate for the top of 
                     % the circle for the first image is defined. 
ybottomNew = ycircNew + rNew; % A vector containing the y-coordinate for the 
                        % bottom of the circle for the first image is defined. 

% The center, top and bottom points of the detected circles are plotted on 
% top of the cropped image.                        
figure
imshow(grayImNewCrop);
hold on
plot(xcircNew,ycircNew,'*')
plot(xcircNew,ytopNew,'.')
plot(xcircNew,ybottomNew,'.')

% The detection order of the cups are plotted on top of the image as well
for i = 1:length(rNew(:,1))
    info = {strcat('cup ', num2str(i))};
    text(xcircNew(i),ycircNew(i),info);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if number of cups match expected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_Big = 42; % Minimum radius of big cup in pixels

NrBig1 = 0; NrMed1 = 0; % Initialization of medium and big cup counters 
                        % for the first image 
                        
% The number of detected medium and big cups in the first image is determined                         
for i = 1:length(rNew(:,1))
    if  rNew(i) >= r_Big  
        NrBig1 = NrBig1 + 1;
    elseif rNew(i) < r_Big
        NrMed1 = NrMed1 + 1;
    end 
end


% If the number of detected medium and big cups for all images is equal to 
% or greater than what is in the order the succes is changed to one. This
% is done to make sure that the number of detected cups is at least the
% number given in the order. The reason its not equal to is that if an
% extra cup that is not part of the order is placed on the turntable the
% script is able to continue.
if NrBig1 >= NrBig && NrMed1 >= NrMed;
    succes = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if number of cups match for all three images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the number of detected cups in all the images is the same the 
% all_same is changed to one. 

if length(xcircNew(:,1)) == size(cupsCombined,2) && length(xcircNew(:,1)) == size(cupsCombined,2)
    all_same = 1;
end

end

% Number of detected cups is determined
numcups = size(cupsCombined,2);

%Create structures where the parameters found by the hough circle detection
%is arranged in structures.
for i=1:numcups    
    cups3(i).x0 = xcircNew(i,1);
    cups3(i).y0 = ycircNew(i,1);
    cups3(i).a=rNew(i,1);     
end

for i=1:numcups   
    PosImg1 = cupsCombined(i).Pos1;
    cups1(i).x0 = PosImg1(1);
    cups1(i).y0 = PosImg1(2);
    if cupsCombined(i).Radius == 4.5
    cups1(i).a = 45; 
    else 
    cups1(i).a = 40; 
    end     
end

for i=1:numcups    
    PosImg2 = cupsCombined(i).Pos2;
    cups2(i).x0 = PosImg2(1);
    cups2(i).y0 = PosImg2(2);
    if cupsCombined(i).Radius == 4.5
    cups2(i).a = 45; 
    else 
    cups2(i).a = 40; 
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compare relative positions to track cup trajectories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cropOffset=[175,75];
imageCentre=[321.3,255.75]; % Determined by cameracalibration
imageCentre=[imageCentre(1)-cropOffset(1),imageCentre(2)-cropOffset(2)];
cropScale=reduce;
H=63.5; % Distance from kinect to turntable [cm].
f=(523.61+524.99)/2; % Determined by cameracalibration

cups1=metricLocation(cups1, cropOffset, cropScale, H, f);
cups2=metricLocation(cups2, cropOffset, cropScale, H, f);
cups3=metricLocation(cups3, cropOffset, cropScale, H, f);
%compare the relative vector magnitudes between each of the images. if two
%sets of cup data share the same diameter and relative distances to
%neighbors, these are the same cup.


%get the vector magnitudes for each of the images
%get the vector magnitude and angles for each of the images
cups1=Vectors_2(cups1);
cups2=Vectors_2(cups2);
cups3=Vectors_2(cups3);


dist_tol = 1.4;
angle_tol = 0.4;
%compare cup sizes and the vector magnitude and direction information for
%all cups over three images to determine which cups are the same over the
%three. this information can be used to measure distance travelled and
%speed of rotation. 

for i=1:numcups
    for j=1:numcups
        for k=1:numcups
            vectorMags1=cups1(i).vectorMags;
            vectorAngs1=cups1(i).vectorAngs;
%             vectorMags1=round(vectorMags1*50)/50; %round to one decimal
% 
            vectorMags2=cups2(j).vectorMags;
            vectorAngs2=cups2(j).vectorAngs;
%             vectorMags2=round(vectorMags2*50)/50;
% 
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
                   
                    cupsCombinedNew(i).Radius=cups1(i).metricRadius;
                    cupsCombinedNew(i).Pos1=pos1;
                    cupsCombinedNew(i).Pos2=pos2;
                    cupsCombinedNew(i).Pos3=pos3;
                    cupsCombinedNew(i).mPos1=cups1(i).MetricPos;
                    cupsCombinedNew(i).mPos2=cups2(j).MetricPos;
                    cupsCombinedNew(i).mPos3=cups3(k).MetricPos;
                    
            else 

                    
                
            end
        end %for k
    end %for j          
end %for i 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if cupsCombined is successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the following two succes criterias are checked to ensure that the 
%determination of which cup is which in every image is successful. 
succes3 = 0;
if size(cups1,2) == size(cupsCombined,2)
    succes3 =1;
end

% The first criteria is to check if any entrances in the resulting
% cupsCombined structure is undefined (this results in [] which is due to a
% tollerance that is too tight).
if succes3 ==1
succes1 = 1;
for i = 1:numcups 
    if sum(size(cupsCombinedNew(i).Radius)) == 0;
        succes1 = 0;
    end
end

% The second criteria is only checked if the first one is succesful. The 
% second criteria checks if any of the entrances in the resulting 
% cupsCombined structure are identical which is not allowed (this is a due 
% to the tolerance being too loose).
if succes1 == 1;
    
    k = 1;
    for i = 1:numcups
        stacked_array(k:k+2,1:2) = [cupsCombinedNew(i).Pos1 ; ...
            cupsCombinedNew(i).Pos2 ; cupsCombinedNew(i).Pos3]; % The position of 
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
                end
        
            end
        
        end
    end
else
    succes2 = 0;  
end
% if size(cupsCombined,2) == size(cupsCombined,2)
else
    succes1 = 0;
    succes2 = 0;
end

% If both criterias are successful the flag is changed to 1 and the while
% loop is thereby exited.
if succes2 == 1 && succes1 == 1 
    flag = 1;
end
% An itteration counter and if statement is added to make sure that the
% code only attempts to update the model three times and if it is not
% succesful the old parameters are used. This is done because the
% determination of which cups is which can have some difficulties if the 
% is very symmetric and the update model gets stuck in an infinite while
% loop if the max number of itteration is not added.
itteration_outer=itteration_outer+1;
if itteration_outer==3
    cupsCombinedNew=cupsCombined;
    t_globalNew=t_global;
     flag = 1;
end

% The metric position in relation to the corner of the image is calculated
% and inserted into the structure
imageMetric=(H/f)*imageCentre;
for i=1:numcups   
    cupsCombinedNew(i).mPos1origin = cupsCombinedNew(i).mPos1 + imageMetric;
    cupsCombinedNew(i).mPos2origin = cupsCombinedNew(i).mPos2 + imageMetric;
    cupsCombinedNew(i).mPos3origin = cupsCombinedNew(i).mPos3 + imageMetric;   
end

% The metric cartesian position of the cups in image 3 is converted to
% polar and added to the structure. This is used to predict the position of
% the cups by taken the given position and adding the angular velocity
% times change in time. 
centre_metric=[x_centerMetric, y_centerMetric];
for i=1:numcups
    poscentre=cupsCombinedNew(i).mPos3origin-centre_metric;
    cupsCombinedNew(i).poscentre = poscentre;
    [theta,r]=cart2pol(poscentre(1),poscentre(2) );
    cupsCombinedNew(i).Theta_R=[theta,r];
end

end
