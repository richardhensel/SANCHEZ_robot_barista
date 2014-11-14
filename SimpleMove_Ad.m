function SimpleMove_Ad()
    loadlibrary('dynamixel','dynamixel.h')
    %libfunctions('dynamixel')                % Display Library Functions
    
    DEFAULT_PORTNUM = 7;   % Com Port
    DEFAULT_BAUDNUM = 34;   % = 57142bps % Baud rate (default 1Mbps)
    
    % open device
    response = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    response
    
    Goal_Pos = 350;     % Position to move to
    Goal_index = 30;    % Index of Command in Library
    Speed_index = 32;    % Index of Command in Library

    pause on;
    
    
    if response == 1 % if port opens okay  
        
       % (calllib('dynamixel','dxl_write_byte',254,3,2))
        
        % Read initial data
        Moving(1) = (calllib('dynamixel','dxl_read_byte',1,46));                  % Read Movement
        PresentPos(1) = int32(calllib('dynamixel','dxl_read_word',1,36));         % Read Position
        
        %Move to first position
        calllib('dynamixel','dxl_write_word',2,Goal_index,Goal_Pos)           % Set goal position
        pause(0.01);
        calllib('dynamixel','dxl_write_word',2,Speed_index,1000)               % Set movement speed

        for (i = 2:51)      % log data
            Moving(i) = (calllib('dynamixel','dxl_read_byte',1,46));                  % Read if Moving
            PresentPos(i) = int32(calllib('dynamixel','dxl_read_word',1,36));         % Read Position
            pause(0.01);    % 'Moving' doesn't work without Pause
        end
        
        pause(0.5);
    
        calllib('dynamixel','dxl_write_word',2,Goal_index,Goal_Pos+300)               % Write goal position
        calllib('dynamixel','dxl_write_word',2,Speed_index,200)               % Write movement speed
                   
        for (i = 52:100)    % log data
            Moving(i) = (calllib('dynamixel','dxl_read_byte',1,46));                  % Read Movement
            PresentPos(i) = int32(calllib('dynamixel','dxl_read_word',1,36));         % Read Position
            pause(0.01);    % 'Moving' doesn't work without Pause
        end
    
        % plot results
        clf
        figure(1)
        hold on
        grid on
        plot(Moving*100,'r','Linewidth',2,'Linesmoothing','on');
        plot(PresentPos,'k','Linewidth',2,'Linesmoothing','on');
        legend('Moving','Position','Location','East');
    else
        disp('Failed to open USB2Dynamixel!');
    end
    calllib('dynamixel','dxl_terminate');
    unloadlibrary('dynamixel');
end