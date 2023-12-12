num_points = 20;

% Generate x and y coordinates for each side
x1 = linspace(-1, 1, num_points);
y1 = -ones(1, num_points);

x2 = ones(1, num_points);
y2 = linspace(-1, 1, num_points);

x3 = linspace(-1, 1, num_points);
y3 = ones(1, num_points);

x4 = -ones(1, num_points);
y4 = linspace(-1, 1, num_points);

% Combine all points
x = [x1, x2, x3, x4];
y = [y1, y2, y3, y4];
points = [x ; y];

scatter(points(1,:),points(2,:))

H1 = [sqrt(3) 0 1;...
      1 -sqrt(3) -1;...
      0 0 1];

H2 = [1 -sqrt(3) 1;...
      sqrt(3) 1 1;...
      0 0 2];

H3 = [sqrt(5) 1 1;...
      -1 sqrt(5) 1;...
      1/2 1/4 2];

H4 = [1 -5 2;...
      0  3 0;...
      sqrt(3) 0 2*sqrt(3)];
rank(H1)
rank(H2)
rank(H3)
rank(H4)
%% Homogeneous coordinate of x and y 
homo_points = [points ;ones(1,length(x)) ];
H1_points = pflat(H1*homo_points);
H2_points = pflat(H2*homo_points);
H3_points = pflat(H3*homo_points);
H4_points = H4*homo_points;

subplot(3,2,1)
scatter(points(1,:),points(2,:),'o','filled')
title('Original shape')

axis([-1.5 1.5 -1.5 1.5])

subplot(3,2,2)
scatter(H1_points(1,:),H1_points(2,:),'o','filled')
title('H1')

subplot(3,2,3)
scatter(H2_points(1,:),H2_points(2,:),'o','filled')
title('H2')

subplot(3,2,4)
scatter(H3_points(1,:),H3_points(2,:),'o','filled')
title('H3')

subplot(3,2,5)
scatter3(H4_points(1,:),H4_points(2,:),H4_points(3,:),'o','filled')
title('H4')
