function setSpeed(id, speed)
%set the speed for the specified motor

%initialise motor
loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

pause on
%set the speed
     if res == 1

        if (speed < 1024)

            calllib('dynamixel','dxl_write_word', id, 32, speed);

        else

            disp('Invalid speed setting.');

        end

    else

        disp('Failed to open USB2Dynamixel!');

     end

%     calllib('dynamixel','dxl_terminate');
%     unloadlibrary('dynamixel');

end



