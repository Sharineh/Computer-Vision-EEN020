function [min_lambda , min_egein_vec , norm_Mv]=estimate_camera_DLT(x,X)
%ESTIMATE_CAMERA_DLT Summary of this function goes here
%   Detailed explanation goes here
% Form the M matrix
M1 = zeros(3*length(X),12);
M2 = zeros(3*length(X),length(x));
X_T = X';
k=0;
for i=1 : length(X)
    for j = 1 :3
        M1(k+j,4*(j-1)+1:4*(j-1)+4) = X_T(i,:);
        M2(k+j,i) = -x(j,i);
    end
    k = k+j;

end
M = [M1 M2];

[~ , S ,V] = svd(M);

S_tr_S = S'*S;

min_lambda = S_tr_S(end:end);

min_egein_vec = V(:,end);

norm_Mv = norm(M*min_egein_vec);

