function [ ] = moveToCondimentReady(caddyLoc, item, location)
    %move arm to ready position next to desired condiment for pickup. 
    %this location is taken from the nearest full location of caddy, and
    %the corresponding caddyloc entry
    setGoal(1, caddyLoc(item, location, 1) + 20 );
    disp(caddyLoc(item, location, 1) + 17);
    setGoal(2, caddyLoc(item, location, 2));
    disp(caddyLoc(item, location, 2));
    setGoal(3, caddyLoc(item, location, 3));
    disp(caddyLoc(item, location, 3));    

end

