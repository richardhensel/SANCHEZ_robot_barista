function [ x,y,yt,yb ] = getCircles( image,tform,min_radius,max_radius,thresh )

[outputImage xdata ydata] = imtransform(image,tform ); %,'size', size(image));%REMOVE SIZE
[outputImagetest] = imtransform(image,tform);

[orsizey,orsizex] = size(image);
[sizey,sizex] = size(outputImagetest);


circles = houghcircles(outputImage, min_radius, max_radius,thresh,20);
houghcircles(outputImage, min_radius, max_radius,thresh,20)

% BW1 = edge(outputImage,'sobel');
% BW2 = edge(outputImage,'canny');
% BW3 = edge(outputImage,'prewitt');
% BW4 = edge(outputImage,'roberts');
% BW5 = edge(outputImage,'log');
% figure
% imshow(BW1);
% figure
% imshow(BW2);
% figure
% imshow(BW3);
% figure
% imshow(BW4);
% figure
% imshow(BW5);
% 

r = circles(:,3);
xcirc = circles(:,1);
ycirc = circles(:,2);

ytop = ycirc - r;
ybottom = ycirc + r;


x = zeros(length(xcirc));
y = zeros(length(xcirc));
yt = zeros(length(xcirc));
yb = zeros(length(xcirc));

for i = 1:length(xcirc)

newx = xcirc(i) + xdata(1);
newy = ycirc(i) + ydata(1);
[xback, yback] = tforminv(tform, newx, newy);

    
ytnew = ytop(i) + ydata(1);
ybnew = ybottom(i) + ydata(1);
[xbackt,ybackt] = tforminv(tform, newx,ytnew);
[xbackb,ybackb] = tforminv(tform, newx,ybnew);
    

x(i) = xback;
y(i) = yback;
yt(i) = ybackt;
yb(i) = ybackb;

end
end



% newx = xcirc(i)*sizex/orsizex + xdata(1);
% newy = ycirc(i)*sizey/orsizey + ydata(1);
% [xback, yback] = tforminv(tform, newx, newy);
% 
%     
% ytnew = ytop(i)*sizey/orsizey + ydata(1);
% ybnew = ybottom(i)*sizey/orsizey + ydata(1);
% [xbackt,ybackt] = tforminv(tform, newx,ytnew);
% [xbackb,ybackb] = tforminv(tform, newx,ybnew);
%     
% 
% x(i) = xback
% y(i) = yback
% yt(i) = ybackt;
% yb(i) = ybackb;
