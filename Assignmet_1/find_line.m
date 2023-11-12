function[a,b,c] = find_line(point1,point2)
% Define the two points in 3D

% Calculate the direction vector of the line
m = (point1(2)-point2(2))/(point1(1)-point2(1));
intercept = point1(2) -(m*point1(1));
a = -m;
b = 1 ;
c = -intercept;
end