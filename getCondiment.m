function [ caddy, location ] = getCondiment( caddy, type )
%return the location of the condiment and update the caddy to remove the condiment from memory 
    count = 1;

    while count ~= 0

        if caddy(type, count) == 1
            
            caddy(type, count) = 0;
            
            if (type == 1 &&  mod(count,2) ~= 0)%odd == row 1 
                row = 1;
            elseif (type == 1 &&  mod(count,2) == 0)%even == row 2
                row = 2;
            elseif (type == 2 &&  mod(count,2) ~= 0)%odd == row 3
                row = 3;
            elseif (type == 2 &&  mod(count,2) == 0)%even == row 4
                row = 4;
            elseif (type == 3)
                row = 5;
            end
            
            rowReady(row);
            location = count;
            
            count = 0;
            
        elseif caddy(type, count) == 0
            
            count = count + 1;
        
        end
    end
 
end

