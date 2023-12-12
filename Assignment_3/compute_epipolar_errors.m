function [l,distances,error] = compute_epipolar_errors(F,x1s,x2s)
%COMPUTE_EPIPOLAR_ERROS Summary of this function goes here
%   Detailed explanation goes here
l = F * x1s;
l = l ./ sqrt(repmat( l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));
distances = abs(sum(l.*x2s));
error = mean(distances);
end

