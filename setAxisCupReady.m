function setAxisCupReady( )
%move to ready position
    setGoal(3, 212);
    pause(0.25);
    setGoal(2, 200);
    pause(0.1);
    setGoal(1, 512);
    setGoal(4, 1990);

end

