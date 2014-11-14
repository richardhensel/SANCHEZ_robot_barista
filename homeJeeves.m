function homeJeeves( )
%return arm to home position

%initialise dynamixels
loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 4;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    
    if res == 1
      %set speed to low  
        setSpeed(1, 100);
        setSpeed(2, 50);
        setSpeed(3, 100);
        setSpeed(4, 100);
       %move to position 
        setGoal(4, 1990);%jaws closed
        setGoal(1, 1023);
        pause(1);

        setGoal(3, 37);
        
        pause(2.5);
        
        setGoal(2, 244);

    end
    
% calllib('dynamixel','dxl_terminate');
% unloadlibrary('dynamixel');

end

