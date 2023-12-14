function [E , erms,x1_inliers,x2_inliers] = estimate_E_robust(k,x1s,x2s)
%ESTIMATE_E_ROBUST Summary of this function goes here
%   Detailed explanation goes here
err_thershold = 2/k(1,1);
x1_norm = pflat(k^-1* x1s);
x2_norm = pflat(k^-1* x2s);
indices = randperm(length(x1_norm), 8);
x1_norm_rand = x1_norm(:,indices);
x2_norm_rand = x2_norm(:,indices);
num_points = length(x1s);
E_approx = estimate_F_DLT(x1_norm_rand,x2_norm_rand);
E = enforce_essential(E_approx);
[~,error1,~] = compute_epipolar_errors(E,x1_norm,x2_norm);
[~,error2,~] = compute_epipolar_errors(E',x2_norm,x1_norm);
inliers = (error1.^2+error2.^2)/2 < err_thershold^2;
num_inliers = sum(inliers);

alpha = 0.98;
eps=0.1;
s=8;
T = log10(1-alpha)/log10(1-eps^s); 
while T >= 0
indices = randperm(length(x1_norm), 8);
x1_norm_rand = x1_norm(:,indices);
x2_norm_rand = x2_norm(:,indices);

E_approx = estimate_F_DLT(x1_norm_rand,x2_norm_rand);
E_new = enforce_essential(E_approx);
[~,error1_new,~] = compute_epipolar_errors(E_new,x1_norm,x2_norm);
[~,error2_new,~] = compute_epipolar_errors(E_new',x2_norm,x1_norm);
inliers_new = (error1_new.^2+error2_new.^2)/2 < err_thershold^2;
num_inliers_new = sum(inliers_new);
if num_inliers_new > num_inliers
    num_inliers = num_inliers_new;
    E = E_new;
    error1 = error1_new;
    error2 = error2_new;
    x1_inliers = x1s(:,inliers_new);
    x2_inliers = x2s(:,inliers_new);
end
if eps < num_inliers/num_points
    eps = num_inliers/num_points;
    T = ceil(log10(1-alpha)/log10(1-eps^s));
end
T = T - 1;
end
erms = sqrt((0.5/length(x1s))*sum(error1.^2 + error2.^2));
end

