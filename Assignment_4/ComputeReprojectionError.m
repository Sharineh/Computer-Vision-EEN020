function [err,res] = ComputeReprojectionError(P_1,P_2,X_j,x_1j,x_2j)
%COMPUTEREPROJECTIONERROR Summary of this function goes here
%   Detailed explanation goes here
res =  [ x_1j(1) - (P_1(:,1)*X_j/P_1(:,3)*X_j) ;
         x_1j(2) - (P_1(:,2)*X_j/P_1(:,3)*X_j) ;
         x_2j(1) - (P_2(:,1)*X_j/P_2(:,3)*X_j) ;
         x_2j(2) - (P_2(:,2)*X_j/P_2(:,3)*X_j) ];
err = sum(norm(res)^2);
end
