function [distance] = point_line_distance_2D(line,point)
%POINT_LINE_DISTANCE_2D Summary of this function goes here
%   Detailed explanation goes here
% compute the distance between a point and a line in 2D
distance = abs(line(1)*point(1) + line(2)*point(2) + line(3))/sqrt(line(1)^2+line(2)^2);
end

