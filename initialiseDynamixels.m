function initialiseDynamixels( )
    %initialise dynamixel speed and move to initial position near caddy
    
    %initialise dynamixels
    loadlibrary('dynamixel', 'dynamixel.h');
    libfunctions('dynamixel');
    
    DEFAULT_PORTNUM = 4;  %COM3
    DEFAULT_BAUDNUM = 1;  %1Mbps

      res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
       
     

        if res == 1
            %speed and movement
             setAllSpeedsSlow();
             setAxisReady();
        else
            disp('Failed to open USB2Dynamixel!');
        end

%     calllib('dynamixel','dxl_terminate');
%     unloadlibrary('dynamixel');

end

