function [center,axis] = camera_center_and_axis(P)
%CAMERA_CENTER_AND_AXIS Summary of this function goes here
%   Detailed explanation goes here
[~,R,center,~,~]=DecomposeCamera(P);
R = R';
axis = R(:,3);
end

