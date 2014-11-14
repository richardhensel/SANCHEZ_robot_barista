function [ ] = rowReady( row )
    %specifies the locations of 'ready' points for each row in the caddy
    rowReadyCoordinates = [ 918 300 228;
                            918 302 220;
                            927 300 199;
                            931 295 174;
                            943 286 143 ];
    %move to the position
    setGoal(1, rowReadyCoordinates(row, 1));
    pause(1);
    setGoal(2, rowReadyCoordinates(row, 2));
    setGoal(3, rowReadyCoordinates(row, 3));

end

