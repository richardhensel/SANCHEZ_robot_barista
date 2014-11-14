function [ caddy ] = getItem( caddyLoc, caddy, item )
%Performs movement to retrieve the specified condiment and return to
%position near turntable

%initialise dynamixels
loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    
    if res == 1
        %get locations
        [caddy, location] = getCondiment(caddy, item);
        blocking();
        %MOVE AND PICK UP CONDIMENT HERE
        moveToCondimentReady(caddyLoc, item, location);
        blocking();
        graspCondiment(caddyLoc, item, location);
        blocking();
        withdrawCondiment(caddyLoc, item, location);
        blocking();
        setAllSpeedsFast();
        blocking();
        moveToNeutralPosition();
        blocking();

    else
        
        disp('Failed to open USB2Dynamixel!');
        
    end
    
% calllib('dynamixel','dxl_terminate');
% unloadlibrary('dynamixel');

end

