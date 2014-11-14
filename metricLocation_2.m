function[cups]=metricLocation_2(cups, cropOffset, cropScale, H, f)
%Returns metric location from corner of the image in the turntable plane. 

%Hcup=[11,9];%two possible heights for big and medium cups
for i=1:size(cups,2)
    i=i
    r=cups(i).a
    
    if r>=37 && r<=42
        Rcup=4;
        Hcup=9.25;
    elseif r>=43 && r<=47
        Rcup=4.5;
        Hcup=10.5;
    else
        Rcup=0;
        Hcup=10.5;
    end
    
    Z=H-Hcup;
    Rcalc=(Rcup*Z/f)*1/cropScale;
    
    cups(i).metricRadius=Rcup;
    cups(i).calculatedRadius=Rcalc;
    cups(i).metricHeight=Hcup;
    
    
    x0=cups(i).x0
    y0=cups(i).y0
    
    x=x0*1/cropScale + cropOffset(1)
    y=y0*1/cropScale + cropOffset(2)
    
    Z=H-Hcup
   
    X=(Z/f)*x
    Y=(Z/f)*y
    
    
    cups(i).MetricPos=[X,Y,Hcup];
    end
    

    
    