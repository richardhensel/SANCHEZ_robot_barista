function [ isMoving ] = readIsMoving( motorID )
    %determine if the specified motor is moving
    
    %initialise the dynamixels
    loadlibrary('dynamixel', 'dynamixel.h');
    libfunctions('dynamixel');
    DEFAULT_PORTNUM = 4;  %COM3
    DEFAULT_BAUDNUM = 1;  %1Mbps

    res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

    if res == 1
        %detect if moving
        isMoving = calllib('dynamixel','dxl_read_byte', motorID, 46);
        
    else
        disp('Failed to open USB2Dynamixel!');
    end


end

