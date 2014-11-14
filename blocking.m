function blocking( )
% blocking remains active until movement of arm is complete. 
%this stops any further commands form being sent until the previous is
%complete



    while (readIsMoving(1) == 1 || readIsMoving(2) == 1 || readIsMoving(3) == 1)
        pause(0.1);
    end

end