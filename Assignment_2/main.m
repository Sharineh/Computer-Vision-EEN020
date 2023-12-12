data = load("A2data/data/compEx1data.mat");
H_points_3D = data.X;
Ps = data.P;
img_points = data.x;
img_names = data.imfiles;
scatter3(H_points_3D(1,:),H_points_3D(2,:),H_points_3D(3,:),'.')
hold on
for i = 1 : length(Ps)
plotcams(Ps(i))
end
axis equal
%%
% Poject points on camera 1
img = imread(img_names{1});
flat_img1_points = pflat(img_points{1});

proj_points = Ps{1} * H_points_3D;
proj_points = pflat(proj_points);

visible = isfinite(proj_points(1,:));

imshow(img)
hold on                                                                                 
plot(proj_points(1,visible),proj_points(2,visible),'.')
plot(flat_img1_points(1,visible),flat_img1_points(2,visible),'o') 
axis equal
%%
% Projective transformation
T1 = [1 0 0 0; 0 3 0 0; 0 0 1 0; 1/8 1/8 0 1];
T2 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1];

X_p1 = pflat(T1 * H_points_3D);
X_p2 = pflat(T2 * H_points_3D);

Ps_p1 = cell(1,9);
Ps_p2 = cell(1,9);
for i = 1 :length(Ps)
    Ps_p1{i} = Ps{i} * T1^(-1);
    Ps_p2{i} = Ps{i} * T2^(-1);
end
% First transformation
scatter3(X_p1(1,:),X_p1(2,:),X_p1(3,:),'.')
hold on
axis equal
for i = 1 :length(Ps)
    plotcams(Ps_p1(i))
end
% Second transformation
figure(2)
scatter3(X_p2(1,:),X_p2(2,:),X_p2(3,:),'.')
hold on
axis equal
for i = 1 :length(Ps)
    plotcams(Ps_p2(i))
end

%% plots
project_and_plot(Ps_p1{1},X_p1,img_names{1})
hold on 
project_and_plot(Ps_p2{1},X_p2,img_names{1})
hold on 
img_points_1 = pflat(img_points{1});
plot(img_points_1(1,:),img_points_1(2,:),'o')
legend('Reconstruction from T1 view 1','Reconstruction from T2 view 1','Image 1 points')

%% Computer Exercise 2
data_ex2 = load("Assignment_2/A2data/data/compEx3data.mat") ;
meas_points_1 = data_ex2.x{1};
meas_points_2 = data_ex2.x{2};

x1_mu = mean(meas_points_1(1,:));
y1_mu = mean(meas_points_1(2,:));
x2_mu = mean(meas_points_2(1,:));
y2_mu = mean(meas_points_2(2,:));
x1_std = std(meas_points_1(1,:));
y1_std = std(meas_points_1(2,:));
x2_std = std(meas_points_2(1,:));
y2_std = std(meas_points_2(2,:));
N1 = [1/x1_std 0 -x1_mu/x1_std; 0 1/y1_std -y1_mu/y1_std; 0 0 1];
N2 = [1/x2_std 0 -x2_mu/x2_std; 0 1/y2_std -y2_mu/y2_std; 0 0 1];
norm_meas_points_1 = N1 * meas_points_1 ;
norm_meas_points_2 = N2 * meas_points_2 ;

subplot(1,2,1)
plot(meas_points_1(1,:),meas_points_1(2,:),'.')
title('Unnormlaized data points (Camera 1)')
subplot(1,2,2)
plot(norm_meas_points_1(1,:),norm_meas_points_1(2,:),'.')
title('Normlaized data points(Camera 1)')


figure(2)
subplot(1,2,1)
plot(meas_points_2(1,:),meas_points_2(2,:),'.')
title('Unnormlaized data points(Camera 2)')
subplot(1,2,2)
plot(norm_meas_points_2(1,:),norm_meas_points_2(2,:),'.')
title('Normlaized data points(Camera 2)')
%% DLT
points_3D = [data_ex2.Xmodel ; ones(1,length(data_ex2.Xmodel))];
[min_lambda_1 , min_egein_vec_1 , norm_Mv_1]=estimate_camera_DLT(norm_meas_points_1,points_3D);
[min_lambda_2 , min_egein_vec_2 , norm_Mv_2]=estimate_camera_DLT(norm_meas_points_2,points_3D);

P1 = reshape(-min_egein_vec_1(1:12),[4 3])';
P2 = reshape(-min_egein_vec_2(1:12),[4 3])';
P1_n = N1^(-1) * P1;
P2_n = N2^(-1) * P2;
Proj_1 = pflat(P1_n * points_3D);
Proj_2 = pflat(P2_n * points_3D);

cube_1 = imread("A2data/data/cube1.JPG");
cube_2 = imread("A2data/data/cube2.JPG");

figure(1)
imshow(cube_1)
hold on
plot(Proj_1(1,:),Proj_1(2,:),'o')
plot(meas_points_1(1,:),meas_points_1(2,:),'*')
hold off
legend('projected points','measured points')

figure(2)
imshow(cube_2)
hold on
plot(Proj_2(1,:),Proj_2(2,:),'o')
plot(meas_points_2(1,:),meas_points_2(2,:),'*')
legend('projected points','measured points')
%% 3D plots

plot_camera(P1_n,30)
hold on 
plot_camera(P2_n,30)
hold on
plot3(points_3D(1,:),points_3D(2,:),points_3D(3,:),'*')
legend("camera center","camera axis")
%% inner params
[K ,RT] = rq(P1_n);
%% Computer Ex 3

[ f1 , d1 ] = vl_sift ( single ( rgb2gray ( cube_1 )) , 'PeakThresh' , 1);

% imshow(cube_1)
% hold on
% vl_plotframe ( f1 );

[ f2 , d2 ] = vl_sift ( single ( rgb2gray ( cube_2 )) , 'PeakThresh' , 1);
[ matches , scores ] = vl_ubcmatch ( d1 , d2 );

x1 = [f1(1 , matches(1 ,:)); f1(2 , matches(1 ,:))];
x2 = [ f2(1 , matches(2 ,:)); f2(2 , matches(2 ,:))];

perm = randperm ( size ( matches ,2));
figure ;
imagesc ([ cube_1 cube_2]);
hold on ;
plot ([ x1(1 , perm(1:10)); x2(1 , perm(1:10))+ size( cube_1 ,2)] , ...
[ x1(2 , perm(1:10)); x2(2 , perm (1:10))] , ' - ' );
hold off ;
%% Computer Ex 4
% Matching points
X = triangulate_3D_point_DLT(P1_n, P2_n, x1, x2);
X_proj_1 = pflat(P1_n * X);
X_proj_2 = pflat(P2_n * X);

% plots
figure(1)
subplot(2,1,1)
imshow(cube_1)
hold on
plot(x1(1,:),x1(2,:),'*')
hold on
plot(X_proj_1(1,:),X_proj_1(2,:),'.')
legend('SIFT points','Computed points')

subplot(2,1,2)
imshow(cube_2)
hold on
plot(x2(1,:),x2(2,:),'*')
hold on
plot(X_proj_2(1,:),X_proj_2(2,:),'.')
legend('SIFT points','Computed points')
%%
% Matching normalaized points 
[K1 , RT1] = rq(P1_n);
[K2 , RT2] = rq(P2_n);

x1_n = pflat(K1^-1 * [x1 ; ones(1,length(x1))]);
x2_n = pflat(K2^-1 * [x2 ; ones(1,length(x1))]);

X_n = triangulate_3D_point_DLT(RT1,RT2,x1_n,x2_n);

X_proj_1_n = pflat(P1_n * X_n);
X_proj_2_n = pflat(P2_n * X_n);

err_1_n = sqrt(sum((x1(1:2,:) - X_proj_1_n(1:2,:)).^2));
err_2_n = sqrt(sum((x2(1:2,:) - X_proj_2_n(1:2,:)).^2));

goodPoints_n = (err_1_n < 3 & err_2_n < 3);
X_good_n = pflat(X_n(:, goodPoints_n));


% Plots for normlaized points
figure(2)
subplot(2,1,1)
imshow(cube_1)
hold on
plot(x1_n(1,:),x1_n(2,:),'*')
hold on
plot(X_proj_1_n(1,:),X_proj_1_n(2,:),'.')
legend('SIFT points','Computed points')

subplot(2,1,2)
imshow(cube_2)
hold on
plot(x2_n(1,:),x2_n(2,:),'*')
hold on
plot(X_proj_2_n(1,:),X_proj_2_n(2,:),'.')
legend('SIFT points','Computed points')
%%
% 3D plot
figure(3)

plot3(X_good_n(1,:),X_good_n(2,:),X_good_n(3,:),'.')
hold on 
plot3(points_3D(1,:),points_3D(2,:),points_3D(3,:),'*')
hold on
plot_camera(P1_n,30)
hold on 
plot_camera(P2_n,30)
legend("3D points","Cube model")
