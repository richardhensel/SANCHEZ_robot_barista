function[cups]=metricLocation(cups, cropOffset, cropScale, H, f)
%Returns metric location from corner of the image in the turntable plane. 

%metric location is calculated under the assumption that the camera is
%positioned directly above the cups in an orthograpic alignment. 

%cups is a structure array containing pixel radius and position for each
%cup in the cropped image

%cropoffset is the offset from the corner of the cropped image to the
%corner o fthe original image

% cropScale is the scaling factor applied to the cropped image

%H is the height of the camera above the scene in cm

% f is the focal length of the calibrated camera. 


%determine the centre of the original image within the cropped image
imageCentre=[321.3-cropOffset(1),255.75-cropOffset(2)];
%centre of the image in metric coordinates from the corner of the cropped
%image
imageMetric=(H/f)*imageCentre;

%use pixel radius to determine metric radius according to known sizes
%through obnservation. 

% large cups have a radius of 4.5cm and a height of 10.5cm
%medium cups have a radius of 4cm and a height of 9.25 cm
for i=1:size(cups,2)
    r=cups(i).a;
    
    if r>=37 && r<=40
        Rcup=4;
        Hcup=9.25;
    elseif r>=41 && r<=47
        Rcup=4.5;
        Hcup=10.5;
    else
        Rcup=0;
        Hcup=10.5;
    end
   
    
    Rcalc=(Rcup*Z/f)*1/cropScale;
    
    %add cup geometry information to the structure array
    cups(i).metricRadius=Rcup;
    cups(i).calculatedRadius=Rcalc;
    cups(i).metricHeight=Hcup;
    
    %determine metric location from pixel location
    %x0 and y0 indicate the xy coordinates of each cup in pixel units from
    %the corner of the cropped image
    x0=cups(i).x0;
    y0=cups(i).y0;
    
    %determine location of the cups relative to the pixel centre of the
    %image
    x=x0-imageCentre(1);
    y=y0-imageCentre(2);
    
     %determine distance from camera to cup top by subtracting cup height
    Z=H-Hcup;

    %determine metric location of the cup relative to the centre of the
    %image
    X=(Z/f)*x;
    Y=(Z/f)*y;
 %add metric location information to the structure array
    MetricPos=[X,Y];
    cups(i).MetricPos=MetricPos;
end

end
    

    
    