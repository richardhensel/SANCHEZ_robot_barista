function [x_centerIni, y_centerIni] = initialize_func(initialize)


if initialize == 1
    % Set up video input and trigger mode
vid = videoinput('kinect',1,'RGB_640x480');
triggerconfig(vid, 'manual') %The triggermode is set to manual to make the 
                             %image capturing more efficient. This mode 
                             % means that the connection to the kinect is 
                             % opened then the specified number of images is 
                             % taken and at the end the connection is stopped. 
                             % If manual trigger mode is not specified the 
                             % connection is opened and stop for every image. 
%%% Adjustable parameters for the image capturing
itteration = 0; % An itteration counter for the image capturing is intialized
max_itteration = 10; % Maximum nummer of itterations are specified
succes = 0; % A succes 
                             
while succes == 0 && (itteration < max_itteration) 
    itteration = itteration + 1;
% Start image acquisition but not logging 
start(vid);
% Start logging data
trigger(vid);


tic
t_start(1,1) = toc;
img = getsnapshot(vid);
t_stop(1,1) = toc;

stop(vid);
disp('Images captured it took')
t_stop(1,1)

%Change pictures to gray scale, crop and scale down


grayIm = rgb2gray(img);
grayImCrop = imcrop(grayIm,[175 75 300 300]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Circle detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Minimun radius for the circles in the transformed image
min_rad = 90;
%Maximum radius for the circles in the transformed image
max_rad = 100;
%Threshold between 0 and 1
thresh = .42;

%Get x and y positions for the circles in the original image. Also the y
%values for the top and the bottom of the circles

%%% Image 1
t1 = toc;
circles1 = houghcircles(grayImCrop, min_rad, max_rad,thresh,20);
disp('Cicle detection on image took')
t2 = toc;
t2-t1

r1 = circles1(:,3);
x_centerIni = circles1(:,1);
y_centerIni = circles1(:,2);

ytop1 = y_centerIni - r1;
ybottom1 = y_centerIni + r1;

figure
imshow(grayImCrop);
hold on
plot(x_centerIni,y_centerIni,'*')
plot(x_centerIni,ytop1,'.')
plot(x_centerIni,ybottom1,'.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Check if turntable is found
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(r1(:,1)) == 1;
    succes = 1;
end

end                             
 

else

x_centerIni = 0;
y_centerIni = 0;
end

    
end




