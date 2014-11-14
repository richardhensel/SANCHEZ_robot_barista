function [ ] = jawsClosed( )
    %close jaws by moving motor 4
    setGoal(4, 1990);%jaws closed

end

