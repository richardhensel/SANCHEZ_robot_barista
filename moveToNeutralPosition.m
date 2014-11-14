function [ ] = moveToNeutralPosition()
%perform movement to neutral position near to turntable

%initialise dynamixels
loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    
    if res == 1
        %get angles required for move to coocrd
         q = rotAngles(250, 0, 250);
         %convert angles to form accepted by dynamixel
         q(1) = convertAngle(q(1));
         q(2) = convertAngle(q(2));
         q(3) = convertAngle(q(3));
         %move to these angles
         setGoal(2, q(2));
         setGoal(3, q(3));
         setGoal(1, q(1));
         
    else

        disp('Failed to open USB2Dynamixel!');

    end

% calllib('dynamixel','dxl_terminate');
% unloadlibrary('dynamixel');

end