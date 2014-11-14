function [ ] = graspCondiment(caddyLoc, type, location)
    %perform action to open jaws, move next to condiment and close jaws to
    %grasp
    jawsOpen();
    pause(0.2);
    setGoal(1, caddyLoc(type, location, 1));
    pause(0.2);
    jawsClosed();

end

