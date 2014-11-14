function[cup_prediction]=predict_cup(cups,cup_number, omega, time, center )
%use the information gained from computer vision to predict the location of
%a specified cup at any time in the future
 

transAngle=time*omega;%the total angle moved since the initial point

x0=center(1);
y0=center(2) ;%location of the centee of the turntable relative to the origin
a=23/2;%radius of the turntable

%for plotting the turntable
t = linspace(0,2*pi,1000);  
x = x0 + a * cos(t) ;
y = y0 + a * sin(t) ;

%clf %clear current plot
close all
set(gca,'YDir','reverse');
plot(x0, y0, 'marker', 'o', 'color', 'black'),hold on, axis equal
plot(x,y, 'color', 'black')

%extract information about the specified cup
 theta=cups(cup_number).Theta_R(1);        
 Theta=theta+transAngle;
 
 R=cups(cup_number).Theta_R(2);
 [x0,y0]=pol2cart(Theta,R);
 %location of the cup relative to the origin        
 x0=x0+center(1)
  y0=y0+center(2)
    
 
 a=cups(cup_number).Radius;
%for ploting the cup 
 t = linspace(0,2*pi,1000);  
x = x0 + a * cos(t) ;
y = y0 + a * sin(t) ;

%clf %clear current plot

plot(x0, y0, 'marker', '+', 'color', 'blue'),hold on, axis equal
plot(x,y, 'color', 'blue')
%return predicted cup location
cup_prediction=[x0,y0];
        
end        
        
        
        
        
        
        
        

