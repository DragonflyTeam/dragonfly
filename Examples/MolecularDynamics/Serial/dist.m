function [d dr] = dist(Nd, R1, R2)
%DIST Summary of this function goes here
%   Detailed explanation goes here

d=0.0;
dr =R1-R2;
for i=1:Nd
    d = d + dr(i)*dr(i);
end
d= sqrt(d);
end

