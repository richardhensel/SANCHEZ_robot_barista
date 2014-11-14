loadlibrary('dynamixel','dynamixel.h');
libfunctions('dynamixel');


DEFAULT_PORTNUM = 4; % com3
DEFAULT_BAUDNUM = 1; % 1mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM)

if res == 1
             setAllSpeedsSlow();
             setAxisReady();
        else
            disp('Failed to open USB2Dynamixel!');
        end