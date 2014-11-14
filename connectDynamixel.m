function [ res ] = connectDynamixel()
    %initialise dunamixel parameters
    loadlibrary('dynamixel', 'dynamixel.h');
    %libfunctions('dynamixel');
    DEFAULT_PORTNUM = 7;  %COM3
    DEFAULT_BAUDNUM = 1;  %1Mbps
    %get connection
    res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
   
end
