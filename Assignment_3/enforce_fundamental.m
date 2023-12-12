function F = enforce_fundamental(F_approx)
%ENFORCE_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here
[U,S,V] = svd(F_approx);
S(end:end) = 0;
F = U * S * V';
end

