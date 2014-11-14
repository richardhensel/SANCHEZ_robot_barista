clc; clear all; close all

% The initialize variable defines whether or not the initialization funcion
% is used. Default is 0 because the center of theturntable is estimated
% using least square optimization.
initialize = 0; % Initialize = 0 : No output from initialization function
                % Initialize = 1 : Initialization function returns the
                %                  center postion of the turntable in 
                %                  pixels.

% The initialization function was programmed to be able to check the
% accuracy of the estimation of the center of the turntable. It is not used
% by default because the center estimation has been found to sufficiently
% accurate.
[x_centerIni, y_centerIni] = initialize_func(initialize);

% Based on the given order the number of big and medium cups is determined.
% This is used in the setting up a model of the turntable so the vision
% always will find at least the given number of medium and big cups. 
NrBig = 1; 
NrMed = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Setup model of turntable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% It is choosen to use the kinect to set up a model of the turn table. The
% model function determines the intial position of the cups and the angular 
% velocity of the turntable. Based on the change in time, angular velocity
% and initial position of the cups the position of the cups can be 
% estimated at any given time. 

% This function uses the center of the turntable estimated by the
% initialization function and uses it to find the model parameters. 
if initialize == 1
tic
disp('Hit enter when cups are placed on turn table')
pause;
[cupsCombined,omega,rpm,t_global] =...
    Model_parameters_Ini(NrBig,NrMed,x_centerIni,y_centerIni);
disp('Determining model parameters took:')
toc
end

% This function estimates the model paramaters based on three images and 
% hough circle detection 
if initialize == 0
tic
[cupsCombined,omega,rpm,t_global,x_centerMetric,y_centerMetric] ...
    = Model_parameters(NrBig,NrMed);    
disp('Determining model parameters took:')
toc
end

% The model parameters and the change in time is used to estimate the
% cup position
disp('Hit enter when cups position must be estimated')
pause;
t_now = getSeconds;
time = t_now - t_global;
[cupsAtTime] = predictPositions(cupsCombined, omega, time, x_centerMetric,y_centerMetric);

% Because it has been found that the estimated speed is a little bit of
% compared to the actual speed the model parameters are updated using the
% following function. The function only updates the position of the cups
% and the angular velocity is unchanged. 
disp('Hit enter to update model')
pause;
tic
[cupsCombinedNew,t_globalNew] = ModelUpdate(NrBig,NrMed,cupsCombined,x_centerMetric,y_centerMetric);
disp('Updating model parameters took:')
toc


disp('Hit enter when cups position must be estimated')
pause;
t_now = getSeconds;
timeold = t_now - t_global;
time = t_now - t_globalNew;
[cupsAtTimeOld] = predictPositions(cupsCombined, omega, timeold, x_centerMetric,y_centerMetric);
[cupsAtTimeNew] = predictPositions(cupsCombinedNew, omega, time, x_centerMetric,y_centerMetric);

