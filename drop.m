function [ ] = drop()

loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    
    if res == 1
        
        jawsOpen();
        pause(0.15);
        jawsClosed();
        
    else

        disp('Failed to open USB2Dynamixel!');

    end

    calllib('dynamixel','dxl_terminate');
    unloadlibrary('dynamixel');

end