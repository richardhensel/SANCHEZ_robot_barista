function [ q ] = rotAngles( x, y, z )
    %perform inverse kinematics to determine the joint angles required to
    %an x-y-x position
    
    %this function requires the installation fo Peter Corke's robotics and
    %vision toolbox
    
    %convert to metres
    x = x / 1000;
    y = y / 1000;
    z = (z / 1000) - 0.078;

    %Link descriptions
    %
    L(1) = Link([0 0 0 pi/2]);
    L(2) = Link([0 0 .21585 0]);
%    L(3) = Link([0 .0175 .30646 0]);
%    L(3) = Link([0 0 .30646 0]);
    L(3) = Link([0 0 .30646 0]);
    
    %Creates a serial link from the three created links.
    threelink = SerialLink(L, 'name', 'three link');

    % %desired end-effector pose
    T = transl(x, y, z);

    % %Find preferred angles
%    q = threelink.ikine(T, [0 pi/4 -pi/2], [1 1 1 0 0 0]);
    q = threelink.ikine(T, [0 pi/4 -pi/2], [1 1 1 0 0 0]);
    
%    threelink.plot(q)
    q = q * (180/pi);
    
    q(1) = q(1) + 150;
    q(2) = 150 - q(2);
    q(3) = 150 + q(3) + 2.2;    

end

