%% Computer Exercise 1
clc
clear
set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"
data = load("A3data/data/compEx1data.mat");
im1_points = data.x{1};
im2_points = data.x{2};

% Mean and std img 1
mu_x1 = mean(im1_points(1,:));
mu_y1 = mean(im1_points(2,:));
std_x1 = std(im1_points(1,:));
std_y1 = std(im1_points(2,:));
% Mean and std img 2
mu_x2 = mean(im2_points(1,:));
mu_y2 = mean(im2_points(2,:));
std_x2 = std(im2_points(1,:));
std_y2 = std(im2_points(2,:));
% Normlaization matrices 
 N1 = [1/std_x1 0 -mu_x1/std_x1; 0 1/std_y1 -mu_y1/std_y1; 0 0 1];
 N2 = [1/std_x2 0 -mu_x2/std_x2; 0 1/std_y2 -mu_y2/std_y2; 0 0 1];
% N1 = eye(3);
% N2 = eye(3);
im1_points_n = N1 *im1_points;
im2_points_n = N2 *im2_points;

% Estimation of F
[Fn_approx,~ , ~] = estimate_F_DLT(im1_points_n,im2_points_n);
Fn = enforce_fundamental(Fn_approx);
% plot epipolar constraints
plot ( diag( im2_points_n' * Fn * im1_points_n ))
axis([0 2008 -0.15 0.15])
% Un-normlaized F
F = N2'*Fn*N1;
F = F./F(3,3);
% The epipolar line, the error, the distances
[l,distances,~] = compute_epipolar_errors(F,im1_points,im2_points);
% rand 20 points with corresponding epipolar lines
selectedIndices = randperm(length(im2_points), 20);
rand_im2_points = im2_points(:,selectedIndices);
rand_lines = l(:,selectedIndices);

% Plot rand points and img2
figure(2)
img2 = imread("A3data/data/kronan2.JPG");
imshow(img2)
hold on
scatter(rand_im2_points(1,:),rand_im2_points(2,:),'filled','or')
hold on
rital(rand_lines,'b')
% histogram
figure(3)
histogram(distances ,100);
%% Computer ex 2
clc 
set(gcf,'Visible','on')              % turns current figure "off"
set(0,'DefaultFigureVisible','on');  % all subsequent figures "off"
% Calibration matrix
K = load("A3data/data/compEx2data.mat").K;
% Normalize the img points
im1_points_norm = pflat(K^-1 * im1_points);
im2_points_norm = pflat(K^-1 * im2_points);
% Compute the approx essential matrx
[E_approx , min_lambda , norm_Mv,egein_val] = estimate_F_DLT(im1_points_norm,im2_points_norm);
% Compute the the essential matrix
E = enforce_essential(E_approx);
E = E./ E(end);
% plot Epipolar constraints
plot (diag( im2_points_norm' * E * im1_points_norm ))
axis([0 2008 -10 10])
% Obtain the F matrix from E 
F = convert_E_to_F(E,K,K);
F = enforce_fundamental(F);
F = F ./F(end);
% The epipolar lines, the error, the distances
[l,distances,error] = compute_epipolar_errors(F,im1_points,im2_points);
% rand 20 points with corresponding epipolar lines
selectedIndices = randperm(length(im2_points), 20);
rand_im2_points = im2_points(:,selectedIndices);
rand_lines = l(:,selectedIndices);
% Plots
figure(1)
img2 = imread("A3data/data/kronan2.JPG");
imshow(img2)
hold on
scatter(rand_im2_points(1,:),rand_im2_points(2,:),'filled','or')
hold on
rital(rand_lines,'b')
% Histogram
figure(2)
histogram(distances ,100);
%% Computer ex 3
% Extract P2 from E
clc
P1 = [eye(3) zeros(3,1)];
P2_cell = extract_P_from_E(E);
points = cell(4,1);
[center1,~] = camera_center_and_axis(P1);
for i = 1 : 4
    points{i} = pflat(triangulate_3D_point_DLT(P1,P2_cell{i},im1_points_norm,im2_points_norm));
    [center2, ~] = camera_center_and_axis(P2_cell{i});
    figure(i)
    plot3(points{i}(1,:),points{i}(2,:),points{i}(3,:),'.r')
    grid on
    hold on
    plot_camera(P1,3);
    plot_camera(P2_cell{i},3)
    axis equal
    hold off
end

% Continue with P2{3}
P2 = K * P2_cell{3};
X = points{3};
P2_proj = pflat(P2*X);
img2 = imread("A3data/data/kronan2.JPG");
% Plot projection in the image
figure(5);
imshow(img2);
hold on;
plot(im2_points(1, :), im2_points(2, :), 'bo')
plot(P2_proj(1, :), P2_proj(2, :), 'r*')
legend('Matched Image Points', 'Projected 3D Points')
axis equal;
hold off



