

function[cups]=Vectors_2(cups)

%For each image, draw a series of vectors between each cup in the scene.
%each cup will posess a unique set of relation vectors with all other cups
%and can be identified by comparison with other images. 

%  return structure array containing cup coordinates , with the relative
%  vector magnitudes and direction angles to each of the other cups

%cups is a structure array containing location and radius information
%for each cup in metric dimensions from the centre of the image. 


for i=1:size(cups,2)
    cup1=cups(i).MetricPos;
    for j=1:size(cups,2)
        cup2=cups(j).MetricPos;
        %cup compared to itself - set to zero
        if i==j
            %construct m x n matrix vectors with entries for theta and
            %r
            thetas(i,j)=0;
            rs(i,j)=0;
            
        %cup compared to every other cup take magnitudes and directions
        %from each one to every other
        else
            %vector x =x2-x1, vector y= y2-y1
            %take polar coords to get madnitude and dirction
            [theta,r]=cart2pol((cup2(1)-cup1(1)),(cup2(2)-cup1(2)));
            
            %convert negative angles to their positive equivalent
            if theta<0
                theta=(2*pi)+theta;
            end
            %construct vectors array
            thetas(i,j)=theta;
            rs(i,j)=r;
            [x,y]=pol2cart(theta,r);
%             if i==1
%             plot(x,y,'ro');
%             text(x,y,num2str(j))
%             end
        end
    end
end
%rearrange to vector magnitudes in ascending order
rs=rs;
thetas=thetas;
[rs,index]=sort(rs,2);


%rearrange the angle array in line with the magnitudes array
for i=1:size(thetas,1)

    thetas(i,:)=thetas(i,index(i,:));
end
thetas=thetas;
%remove 1st column (all of the zero magnitudes from cups compared to
%themselves)


rs=rs(:,2:end);
thetas=thetas(:,2:end);



%vectors1=vectors;
for i=1:size(rs,1)
    i=i;
    %for each cup, take mean angle to all other cups and set the mean to 90
    %degrees. this 'normalises' the angles relative to each other
    %regardless of their actual orientation
    
    thetaRow=thetas(i,:);
%    
    thetaMean1=deg2rad(meanangle(rad2deg(thetaRow)));
     if thetaMean1<0
          thetaMean1=(2*pi)+thetaMean1;
     end
      
          thetaCorr=pi/2-thetaMean1;
   

    for j=1:size(thetas,2)
        

            
        thetaAbs=thetas(i,j)+thetaCorr;
        if thetaAbs>2*pi
            thetaAbs=thetaAbs-2*pi;
        elseif thetaAbs<0
            thetaAbs=thetaAbs+2*pi;
        end
        thetas(i,j)=thetaAbs;

        
    end
    thetaRow=thetas(i,:);
    thetaMean2=deg2rad(meanangle(rad2deg(thetaRow)));
     if thetaMean2<0
          thetaMean2=(2*pi)+thetaMean2;
     end

     thetaMean2;
end
rs=rs;
thetas=thetas;

%sort in ascending angles order
[thetas,index]=sort(thetas(:,:),2);
%rs=vectors1(:,:,2);

%sort magnitudes in line with their correspoinding nagles
for i=1:size(rs,1)

    rs(i,:)=rs(i,index(i,:));
end



%add fields to structure output
for i=1:size(rs,1)
    
    cups(i).vectorMags=rs(i,:);
    cups(i).vectorAngs=thetas(i,:);
end



