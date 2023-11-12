% Ploting the given data points 
data = load('compEx1.mat');
data_2D = data.x2D;
data_3D = data.x3D;
data_2D_flat = pflat(data_2D);
data_3D_flat = pflat(data_3D);
plot_points_2D(data_2D_flat)
plot_points_3D(data_3D_flat)

%%
points = load("compEx2.mat");
img = imread("compEx2.jpg");
% find the lines going through points p1 p2 p3
[a , b , c]=find_line(points.p1(1:2,1),points.p1(1:2,2));
[a1 , b1 , c1] = find_line(points.p2(1:2,1),points.p2(1:2,2));
[a2 , b2 , c2] = find_line(points.p3(1:2,1),points.p3(1:2,2));
% intersection between line2 and line3 
x_inter = null([a1 b1 c1;a2 b2 ,c2]);
% Transform to homogenous coordinates
x_inter = pflat(x_inter);
% transforming to homogenous coordinates
line_1 = pflat([a;b;c]);
line_2 = pflat([a1;b1;c1]);
line_3 = pflat([a2;b2;c2]);
% Plot the images, the points, and the lines
imshow(img);
hold on;
plot_points_2D(points.p1)
plot_points_2D(points.p2)
plot_points_2D(points.p3)
plot_points_2D(x_inter)
rital([line_1 line_2 line_3])
% The distance between line 1 and the x_int
d = point_line_distance_2D(line_1,x_inter);

%% Projective transformation
H = [1 1 0; 0 1 1; 0 -1 1];
x1 = [1; 0 ; 1];
x2 = [0 ; 1 ; 1];
y1 = H*x1;
y2 = H*x2;
%% The Pinhole camera
X1 = [1 ,2 ,1 ,1]';
X2 = [1 ,1 ,3 ,1]';
X3 = [2 ,1 ,-1 ,1]';
P = [1, 0 , 0 , 0;...
     0, 1, 0 , 0;...
     0 , 0 ,1 ,-1];
P_X1 = P *X1;
P_X2 = P *X2;
P_X3 = P *X3;
% Camera center
R = P(1:3,1:3);
T = P(:,4);
c = -R' * T;
null_P = null(P);
%% Computer ex 3
img1 = imread('compEx3im1.jpg');
img2 = imread('compEx3im2.jpg');
data  = load("compEx3.mat");
p1 = data.P1;
p2 = data.P2;
u = data.U;
[center_1,axis_1] = camera_center_and_axis(p1);
[center_2,axis_2] = camera_center_and_axis(p2);

% Plot U and the camera centers 
figure;
plot_camera(p1,50);
plot_camera(p2,50);
hold on
plot_points_3D(pflat(u))
% Project  U into p1 and p2

U_poj_1 = p1*u;
U_poj_2 = p2*u;
U_poj_1 = pflat(U_poj_1);
U_poj_2 = pflat(U_poj_2);

% Plot U in the same fig as the camera
figure;
imshow(img1)
hold on
scatter(U_poj_1(1,:),U_poj_1(2,:))
figure;
imshow(img2)
hold on
scatter(U_poj_2(1,:),U_poj_2(2,:))