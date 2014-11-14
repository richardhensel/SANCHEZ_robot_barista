function[cupsAtTime]=predictPositions(cups, omega, time, x_centerMetric,y_centerMetric )


%plot the turntable
x0=x_centerMetric;
y0=y_centerMetric ;
a=23/2;

t = linspace(0,2*pi,1000);  
% x = x0 + a * cos(t) ;
% y = y0 + a * sin(t) ;
x = 0 + a * cos(t) ;
y = 0 + a * sin(t) ;

%clf %clear current plot
figure
set(gca,'YDir','reverse');
% plot(x0, y0, 'marker', 'o', 'color', 'black'),hold on, axis equal
plot(0, 0, 'marker', 'o', 'color', 'black'),hold on, axis equal
plot(x,y, 'color', 'black')

colors={'r';'g';'c';'m';'y'};
transAngle=time*omega;

for i=1:size(cups,2)
        theta=cups(i).Theta_R(1); 
        
       Theta=theta+transAngle;
       R=cups(i).Theta_R(2);
       [x0,y0]=pol2cart(Theta,R);
         
         a=cups(i).Radius;
         color=char(colors(i));
         
        t = linspace(0,2*pi,1000);  
        x = x0 + a * cos(t);
        y = y0 + a * sin(t);
        
        plot(x0, y0, 'marker', '+', 'color', color)
        plot(x,y, 'color', color)
        
        info={strcat('cup  ', num2str(i))} ;%; num2str(cups(i).origindist)}
           
            text(x0, y0-1, info);
        
       cupsAtTime(i).Radius=cups(i).Radius;
       cupsAtTime(i).Theta_R=[Theta,R];
       cupsAtTime(i).x_y=[x0,y0];
        
end        
        
        
        
        
        
        
        

