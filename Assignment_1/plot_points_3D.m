function plot_points_3D(data_points)
%PLOT_POINTS_2D Summary of this function goes here
%   Detailed explanation goes here
    scatter3(data_points(1,:), data_points(2,:),data_points(3,:),'.')
    axis equal
    grid on
    
end

