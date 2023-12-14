%% Computer Exercise 1
clc
clear all
% calibration matrix
K = load("data-2023/data/compEx1data.mat","K").K;
% matched image points
x_match_img1 = load("data-2023/data/compEx1data.mat","x").x{1};
x_match_img2 = load("data-2023/data/compEx1data.mat","x").x{2};
% normalized image points
x_match_img1_n = pflat(K^-1 * x_match_img1);
x_match_img2_n = pflat(K^-1 * x_match_img2);
% aprox the essential matrix form the points
[E_approx, ~,~] = estimate_F_DLT(x_match_img1_n,x_match_img2_n);
E = enforce_essential(E_approx);
% convert E to F
F = convert_E_to_F(E,K,K);
% epiploar lines
l1 = F'*x_match_img2;
l2 = F*x_match_img1;
% root mean square error
[~,distances_2,erms_img2] = compute_epipolar_errors(F,x_match_img1,x_match_img2);
[~,distances_1,erms_img1] = compute_epipolar_errors(F',x_match_img2,x_match_img1);
erms = sqrt((0.5*1/length(x_match_img2))*sum(distances_1.^2 + distances_2.^2));
% Histogram
figure(1)
histogram(distances_1,100)
figure(2)
histogram(distances_2,100)

% rand 20 points with corresponding epipolar lines image 1
selectedIndices = randperm(length(x_match_img1), 20);
rand_im1_points = x_match_img1(:,selectedIndices);
rand_lines_1 = l1(:,selectedIndices);
% rand 20 points with corresponding epipolar lines image 1
selectedIndices = randperm(length(x_match_img2), 20);
rand_im2_points = x_match_img2(:,selectedIndices);
rand_lines_2 = l2(:,selectedIndices);

img1 = imread("data-2023/data/round_church1.jpg");
img2 = imread("data-2023/data/round_church2.jpg");

figure(3)
imshow(img1)
hold on
scatter(rand_im1_points(1,:),rand_im1_points(2,:),'filled','or')
hold on
rital(rand_lines_1,'b')

figure(4)
imshow(img2)
hold on
scatter(rand_im2_points(1,:),rand_im2_points(2,:),'filled','or')
hold on
rital(rand_lines_2,'b')
%%
clc
% RANSAC
[E ,erms_ransac,x_img1_inliers,x_img2_inliers] = estimate_E_robust(K,x_match_img1,x_match_img2);
F = convert_E_to_F(E,K,K);
% epiploar lines
l1 = F'* x_img2_inliers;
l2 = F * x_img1_inliers;
% root mean square error
[~,distances_2,erms_img2] = compute_epipolar_errors(F,x_img1_inliers,x_img2_inliers);
[~,distances_1,erms_img1] = compute_epipolar_errors(F',x_img2_inliers,x_img1_inliers);

% Histogram
figure(1)
histogram(distances_1,100)
figure(2)
histogram(distances_2,100)

% rand 20 points with corresponding epipolar lines image 1
selectedIndices = randperm(length(x_img1_inliers), 20);
rand_im1_points = x_img1_inliers(:,selectedIndices);
rand_lines_1 = l1(:,selectedIndices);
% rand 20 points with corresponding epipolar lines image 1
rand_im2_points = x_img2_inliers(:,selectedIndices);
rand_lines_2 = l2(:,selectedIndices);

img1 = imread("data-2023/data/round_church1.jpg");
img2 = imread("data-2023/data/round_church2.jpg");

figure(3)
imshow(img1)
hold on
scatter(rand_im1_points(1,:),rand_im1_points(2,:),'filled','or')
hold on
rital(rand_lines_1,'b')

figure(4)
imshow(img2)
hold on
scatter(rand_im2_points(1,:),rand_im2_points(2,:),'filled','or')
hold on
rital(rand_lines_2,'b')
%% Computer Exercise 2
fountain1 = imread("data-2023/data/fountain1.png");
fountain2 = imread("data-2023/data/fountain2.png");
K = load("data-2023/data/compEx2data.mat","K").K;
% Extracting features
[ fA , dA ] = vl_sift( single(rgb2gray(fountain1)) ); %39561 features
[ fB , dB ] = vl_sift( single(rgb2gray(fountain2)) ); %38775 features
% match point in the two imgaes
matches = vl_ubcmatch(dA , dB );
%%
% Homogenaizing xA and xB
xA = [fA(1:2 , matches(1 ,:));ones(1,length(matches))];
xB = [fB(1:2 , matches(2 ,:));ones(1,length(matches))];
% Estimate E from vl_sift matches
[E ,erms_ransac,xA_inliers,xB_inliers] = estimate_E_robust(K,xA,xB); % 1689 inliers
% extract P2 from E
P1 = [eye(3) zeros(3,1)];
P2_cell = extract_P_from_E(E);
points = cell(4,1);
[center1,~] = camera_center_and_axis(P1);
for i = 1 : 4
    points{i} = pflat(triangulate_3D_point_DLT(P1,P2_cell{i},K^-1*xA_inliers,K^-1*xB_inliers));
    [center2, ~] = camera_center_and_axis(P2_cell{i});
    figure(i)
    plot3(points{i}(1,:),points{i}(2,:),points{i}(3,:),'.r')
    grid on
    hold on
    plot_camera(P1,2);
    plot_camera(P2_cell{i},2)
    hold off
end
P2 = P2_cell{3};
X = points{3};
%%
clc
data = load("data-2023\data\compEx3data.mat");
P1 = data.P{1};
P2 = data.P{2};
K =  data.K;
x1 = data.x{1};
x2 = data.x{2};
X = data.X;
% before LM
rep_err_vec = zeros(1,length(X));
for i = 1 : length(X)
    rep_err_vec(i) = ComputeReprojectionError(P1,P2,X(:,i),x1(:,i),x2(:,i));
end
median_before = median(rep_err_vec);
error_sum = sum(rep_err_vec);
% LM
r = [];
J = [];
X_opt = zeros(size(X));

for i = 1 : length(X)

    mu = 1;

    while mu > 1e-6 && mu < 1e6

        [r_i,J_i] = LinearizeReprojErr(P1,P2,X(:,i),x1(:,i),x2(:,i)) ;

        delta_x = ComputeUpdate(r_i,J_i,mu);

        new_X = pflat(X(:,i) + delta_x);

        [err_prev,~]   = ComputeReprojectionError(P1,P2,X(:,i),x1(:,i),x2(:,i));

        [err_update,~] = ComputeReprojectionError(P1,P2,new_X,x1(:,i),x2(:,i));

        if err_update < err_prev

            mu = mu / 10;

            X_opt(:,i) = pflat(new_X);

        else

            mu = mu * 10;
            X_opt(:,i) = X(:,i);

        end
    end
end

% After LM
rep_err_vec_lm = zeros(1,length(X_opt));

for i = 1 : length(X_opt)

    rep_err_vec_lm(i) = ComputeReprojectionError(P1,P2,X_opt(:,i),x1(:,i),x2(:,i));

end
error_sum_lm = sum(rep_err_vec_lm);

median_after= median(rep_err_vec_lm);
%% Plots 
plot3(X(1,:),X(2,:),X(3,:),'.')
hold on
plot3(X_opt(1,:),X_opt(2,:),X_opt(3,:),'.')
grid on
legend('3D points','Refined 3D points')

