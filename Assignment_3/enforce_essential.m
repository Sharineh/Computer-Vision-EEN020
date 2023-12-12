function E = enforce_essential(E_approx)
%ENFORCE_ESSENTIAL Summary of this function goes here
%   Detailed explanation goes here
[U ,~ , V ] = svd ( E_approx );
if det( U * V') < 0
V = -V ;
end
E = U * diag([1 1 0]) * V' ;
end

