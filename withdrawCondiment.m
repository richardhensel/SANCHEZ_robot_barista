function [ ] = withdrawCondiment(caddyLoc, type, location)
    %perform 'pull' of condiment from caddy once grasped
    
    %moves to joint angles away from initial position
    setGoal(2, caddyLoc(type, location, 2) - 90);
    setGoal(3, caddyLoc(type, location, 3) - 65);

end
