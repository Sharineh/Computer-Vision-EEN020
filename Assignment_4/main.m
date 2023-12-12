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
% figure(1)
% histogram(distances_1,100)
% figure(2)
% histogram(distances_2,100)

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
[E ,erms_ransac] = estimate_E_robust(K,x_match_img1,x_match_img2);
F = convert_E_to_F(E,K,K);
% epiploar lines
l1 = F'*x_match_img2;
l2 = F*x_match_img1;
% root mean square error
[~,distances_2,erms_img2] = compute_epipolar_errors(F,x_match_img1,x_match_img2);
[~,distances_1,erms_img1] = compute_epipolar_errors(F',x_match_img2,x_match_img1);

% Histogram
% figure(1)
% histogram(distances_1,100)
% figure(2)
% histogram(distances_2,100)

% rand 20 points with corresponding epipolar lines image 1
selectedIndices = randperm(length(x_match_img1), 20);
rand_im1_points = x_match_img1(:,selectedIndices);
rand_lines_1 = l1(:,selectedIndices);
% rand 20 points with corresponding epipolar lines image 1
%selectedIndices = randperm(length(x_match_img2), 20);
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
%% Computer Exercise 2
fountain1 = imread("data-2023/data/fountain1.png");
fountain2 = imread("data-2023/data/fountain2.png");
K = load("data-2023/data/compEx2data.mat","K").K;
[ fA , dA ] = vl_sift( single(rgb2gray(fountain1)) );
[ fB , dB ] = vl_sift( single(rgb2gray(fountain2)) );
matches = vl_ubcmatch(dA , dB );
xA = fA(1:2 , matches(1 ,:));
xB = fB(1:2 , matches(2 ,:));
%%
figure;
imagesc ([ fountain1 fountain2]);
hold on ;
plot ([ xA(1 , perms(1:10)); xB(1 , perms(1:10))+ size( fountain1 ,2)] , ...
[ xA(2 , perms(1:10)); xB(2 , perms(1:10))] , ' - ' );
hold off ;
