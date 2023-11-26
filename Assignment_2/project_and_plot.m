function project_and_plot(P,Xs,image)
%PROJECT_AND_PLOT Summary of this function goes here
%   Detailed explanation goes here
proj_points = pflat( P * Xs);

imshow(image)
hold on 
plot(proj_points(1,:),proj_points(2,:),'.')

end

