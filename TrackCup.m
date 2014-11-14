%function [ cupsCombined ] = TrackCup( RawCups1, RawCups2, RawCups3 )

%TrackCup take cup locations from consecutive photos, recognise individual
%cups and return a structure array containing the different locations of
%each cup between images
%
%needs to use function getVectors to find the vector magnitude between cups for
%each image
%   
%  cupsCombined is an n by 4 structure array where n=number of cups
%  cupsCombined has fields: radius(cm), pos1(x,y coord), pos2, pos3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%first part for testing only - to construct some example inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

x0s=[0;10;0;-10];%x coords
y0s=[10;0;-10;0];%y coords
as=[47;47;47;47];%radii


%create test structures by rotating the original points by transAngle
for i=1:4
    x0=x0s(i);
    y0=y0s(i);
    
    x0=x0+75
    y0=y0+120 
    
   cups1(i).x0=x0;
   cups1(i).y0=y0;
    cups1(i).a=as(i);
    
     
end

transAngle=0.1;
for i=1:4
    j=5-i
        [theta,r]=cart2pol(x0s(i), y0s(i));
         Theta=theta+transAngle;
         R=r;
         a=cups1(i).a;
         [x0,y0]=pol2cart(Theta,R);
         
        x0=x0+75
        y0=y0+120 
         
        t = linspace(0,2*pi,1000);  
        x = x0 + a * cos(t);
        y = y0 + a * sin(t);
        
        cups2(j).x0=x0;
       cups2(j).y0=y0;
        cups2(j).a=a;
end

transAngle=0.2;
for i=1:4
    
         [theta,r]=cart2pol(x0s(i), y0s(i));
         Theta=theta+transAngle;
         R=r;
         a=cups1(i).a;
         [x0,y0]=pol2cart(Theta,R);
         x0=x0+75
        y0=y0+120 
        
        t = linspace(0,2*pi,1000);  
        x = x0 + a * cos(t);
        y = y0 + a * sin(t);
        
         cups3(i).x0=x0;
         cups3(i).y0=y0;
        cups3(i).a=a;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%actual code starts below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cropOffset=[175,75];
cropScale=1;
H=63;
f=528.4;

cups1=metricLocation_2(cups1, cropOffset, cropScale, H, f);
cups2=metricLocation_2(cups2, cropOffset, cropScale, H, f);
cups3=metricLocation_2(cups3, cropOffset, cropScale, H, f);
%compare the relative vector magnitudes between each of the images. if two
%sets of cup data share the same diameter and relative distances to
%neighbors, these are the same cup.

%get the vector magnitude and angles for each of the images
cups1=Vectors_2(cups1);
cups2=Vectors_2(cups2);
cups3=Vectors_2(cups3);

numcups=size(cups1,2);
dist_tol = .7;
angle_tol = 0.1;

for i=1:numcups
    for j=1:numcups
        for k=1:numcups
            vectorMags1=cups1(i).vectorMags;
            vectorAngs1=cups1(i).vectorAngs;
%             vectorMags1=round(vectorMags1*50)/50; %round to one decimal
% 
            vectorMags2=cups2(j).vectorMags;
            vectorAngs2=cups2(j).vectorAngs;
%             vectorMags2=round(vectorMags2*50)/50;
% 
            vectorMags3=cups3(k).vectorMags;
            vectorAngs3=cups1(k).vectorAngs;
%             vectorMags3=round(vectorMags3*50)/50;
        
            if (cups1(i).metricRadius == cups2(j).metricRadius)...
                    && min(abs(vectorMags1 - vectorMags2) < dist_tol) ... 
                    && min(abs(vectorAngs1 - vectorAngs2) < angle_tol)
                if (cups2(j).metricRadius == cups3(k).metricRadius) ...
                        && min(abs(vectorMags2 - vectorMags3) < dist_tol)...
                        && min(abs(vectorAngs2 - vectorAngs3) < angle_tol)
                    
                    pos1=[cups1(i).x0, cups1(i).y0];
                    pos2=[cups2(j).x0, cups2(j).y0];
                    pos3=[cups3(k).x0, cups3(k).y0];
                   
                    cupsCombined(i).Radius=cups1(i).metricRadius;
                    cupsCombined(i).Pos1=pos1;
                    cupsCombined(i).Pos2=pos2;
                    cupsCombined(i).Pos3=pos3;
                    cupsCombined(i).mPos1=cups1(i).MetricPos;
                    cupsCombined(i).mPos2=cups2(i).MetricPos;
                    cupsCombined(i).mPos3=cups3(i).MetricPos;
                    
                    
                end
            end
        end %for k
    end %for j          
end %for i 

%plot the results

for i=1:numcups
    
    pos1=cupsCombined(i).Pos1 %plotted in blue
    pos2=cupsCombined(i).Pos2 %plotted in green
    pos3=cupsCombined(i).Pos3 %plotted in red
    
    plot(pos1(1), pos1(2), 'bo'), hold on, axis on
    plot(pos2(1), pos2(2), 'go')
    plot(pos3(1), pos3(2), 'ro')
end



