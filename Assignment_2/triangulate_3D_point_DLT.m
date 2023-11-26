function X = triangulate_3D_point_DLT(cam1,cam2,points_1,points_2)
%TRIANGULATE_3D_POINT_DLT Summary of this function goes here
%   Detailed explanation goes here
% x1 = points_1(1,:);
% y1 = points_1(2,:);
% x2 = points_2(1,:);
% y2 = points_2(2,:);
X = [];
for i = 1 : length(points_1)
    A = [cam1(1,:) - points_1(1,i) * cam1(3,:); cam1(2,:) - points_1(2,i) * cam1(3,:); cam2(1,:) - points_2(1,i) * cam2(3,:); cam2(2,:) - points_2(2,i) * cam2(3,:)];
    [~, ~, V] = svd(A);
    minEigenvector = V(:, size(V, 2));    
     X = [X minEigenvector(1:4,:)];
end
end

