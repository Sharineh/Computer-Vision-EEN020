function [err,res] = ComputeReprojectionError(P_1,P_2,X_j,x_1j,x_2j)
%COMPUTEREPROJECTIONERROR Summary of this function goes here
%   Detailed explanation goes here
res =  [ x_1j(1) - ( P_1(1,:) * X_j / (P_1(3,:) * X_j) ) ;
         x_1j(2) - ( P_1(2,:) * X_j / (P_1(3,:) * X_j) ) ;
         x_2j(1) - ( P_2(1,:) * X_j / (P_2(3,:) * X_j) ) ;
         x_2j(2) - ( P_2(2,:) * X_j / (P_2(3,:) * X_j) ) ];
err = sum(norm(res)^2);
end

% function [err, res] = ComputeReprojectionError(P_1, P_2, X_j, x1_j, x2_j)
% 
%     p1_1 = P_1(1,:); p1_2 = P_1(2,:); p1_3 = P_1(3,:);
%     p2_1 = P_2(1,:); p2_2 = P_2(2,:); p2_3 = P_2(3,:);
% 
%     res1 = [x1_j(1) - (p1_1 * X_j/(p1_3 * X_j));
%             x1_j(2) - (p1_2 * X_j/(p1_3 * X_j))];
% 
%     res2 = [x2_j(1) - (p2_1 * X_j/(p2_3 * X_j));
%             x2_j(2) - (p2_2 * X_j/(p2_3 * X_j))];
% 
%     res = [res1; res2];
% 
%     err = sum(norm(res)^2);
% end