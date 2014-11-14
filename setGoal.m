function setGoal(id, goal)
%move specified motor to specified angle

%intiailise motor
loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

pause on
%perform move
    if res == 1

        if (id > 0 && id < 4)

            if (goal < 1024)

                calllib('dynamixel','dxl_write_word', id, 30, goal);

            else

                disp('Invalid goal.');

            end

        elseif (id == 4)

            if (goal > 1774 && goal < 1991)

                calllib('dynamixel','dxl_write_word', id, 30, goal);

            else

                disp('Invalid goal.');

            end

        else

            disp('Invalid dynamixel id.');

        end

    else

        disp('Failed to open USB2Dynamixel!');

    end

%     calllib('dynamixel','dxl_terminate');
%     unloadlibrary('dynamixel');

end



