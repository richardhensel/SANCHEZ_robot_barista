function [] = rotateToCaddyHigh(  )
    %move to position near caddy before moving to specific location
    setGoal(4, 1990);%jaws closed
    
    pause(0.5);
    %joint angles of move
    q = rotAngles(220, 280, 300);
    %convert to dynamixel anfles
    q(1) = convertAngle(q(1));
    q(2) = convertAngle(q(2));
    q(3) = convertAngle(q(3));
    %move to point
    setGoal(1, q(1));
    setGoal(2, q(2));
    setGoal(3, q(3));

end

