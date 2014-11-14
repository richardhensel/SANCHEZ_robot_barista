function [rx, ry] = current_position(cx, cy, tnow, r, w, oi1, oi2)
%returns the x-y coordinates of the cup based on the model parameters
o = oi1 - w*t;
rx = cx + r*cos(o);
ry = cy + r*sin(o);
end