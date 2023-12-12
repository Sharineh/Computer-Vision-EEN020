function [Fn , min_lambda , norm_Mv,S_tr_S] = estimate_F_DLT(x1s,x2s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
M = zeros(length(x1s),9);
for i = 1 : length(x1s)
 M(i,1) = x1s(1,i)*x2s(1,i);
 M(i,2) = x1s(1,i)*x2s(2,i);
 M(i,3) = x1s(1,i)*x2s(3,i);
 M(i,4) = x1s(2,i)*x2s(1,i);
 M(i,5) = x1s(2,i)*x2s(2,i);
 M(i,6) = x1s(2,i)*x2s(3,i);
 M(i,7) = x1s(3,i)*x2s(1,i);
 M(i,8) = x1s(3,i)*x2s(2,i);
 M(i,9) = x1s(3,i)*x2s(3,i);
end
[~ , S ,V] = svd(M);

S_tr_S = S'*S;

min_lambda = S_tr_S(end:end);

min_egein_vec = V(:,end);

norm_Mv = norm(M*min_egein_vec);

Fn = reshape(min_egein_vec,[3 3]);
end

