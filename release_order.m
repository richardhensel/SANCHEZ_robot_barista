function release_order(cups, i, omega, t_global, center, info);

%predict the position of the desired cup at a time in the future. send the robot arm to
%this point, and wait for the cup to arrive. drop condiment when cup is
%within the desired range of the robot arm. 

%the chosen time must be longer than it takes for the arm to travel so that
%there is time to wait, and the arm does not arrive later than the target.

%cups is a structure array containing location at the given time, size, and order
%information for each cup

%i is the index number of the current cup of interest within the cups
%structure array

%omega is the angular velocity of the turntable in rad/s

%t_global is the time at which the location was taken in seconds since the
%beginning of the day. 

%center is the metric location of the centre of the turntable

%info is the number of the desired condiment, 1=coffee, 2=tea, 3=sugar

 xdist=49.5;	%distance from image origin to robot base
 ydist=15;		%distance from image to robot base

guess_time=5;%%time to travel and wait for cup


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%PREDICT AND SEND ARM TO POSITION%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
atime=getSeconds()-t_global;	%take time from the initial position
atime=atime+guess_time; 		%time for drop off, robot to move and wait for cup

arm_pos=predict_cup(cups,i, omega, atime, center);	%predicts the position of the
													%desired cup at a point in the future

 
 robot_x=xdist-arm_pos(1);	%determine coordinates of robot arm 
 robot_y=ydist-arm_pos(2);	%these must be transformed from the
							%coordinates determined from the origin
							%of the computer vision values
 
moveToCoords(robot_x*10-25, robot_y*10); %move arm to position
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%DROP AT APPROPRIATE PROXIMITY%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

proximity_tol = 3; 	%distance in centimetres between the robot arm and the cup before the drop can occur
                    %this compensates for the delay between calculated
                    %position and drop occurring. 
drop=0;
while drop==0; %need to constantly calculate position in time
    ctime=getSeconds()-t_global;
    cup_pos=predict_cup(cups,i, omega, ctime, center);
    plot(arm_pos(1), arm_pos(2), 'ro');
    text(arm_pos(1), arm_pos(2), num2str(info))
    pause(0.1);
    
    if norm(pdist([arm_pos; cup_pos],'euclidean')) < proximity_tol;
        drop = 1; 	%breaks loop when predicted cup position is close
					%to the waiting position of the arm
    end
end
blocking(); 			%ensure drop does not occur until stationery. 
dropp(); 				%drop the condiment
blocking();
returnFast();			%return to near initial position with increased speed
blocking();
initialiseDynamixels();	%return to exactly initial position and reset speed to low
blocking();
end