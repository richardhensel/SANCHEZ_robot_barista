function moveToPoint(motor1, motor2, motor3)
%move to a point specified by motor angles these are input in a form
%accepted by dynamixels, not in degrees or radians

    %initialise dynamixels
    loadlibrary('dynamixel', 'dynamixel.h');
    libfunctions('dynamixel');
    DEFAULT_PORTNUM = 4;  %COM3
    DEFAULT_BAUDNUM = 1;  %1Mbps

    res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

    if res == 1
        %move to the location
        setGoal(1, motor1);
        setGoal(2, motor2);
        setGoal(3, motor3);

    else

        disp('Failed to open USB2Dynamixel!');

    end
%     calllib('dynamixel','dxl_terminate');
%     unloadlibrary('dynamixel');
end

