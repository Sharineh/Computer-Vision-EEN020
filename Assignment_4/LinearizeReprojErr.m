function [r,J] = LinearizeReprojErr(P_1,P_2,X_j,x_1j,x_2j)
J = [   (P_1(1,:)*X_j) * P_1(3,:) / (P_1(3,:)*X_j)^2 - P_1(1,:) / (P_1(3,:) * X_j);
        (P_1(2,:)*X_j) * P_1(3,:) / (P_1(3,:)*X_j)^2 - P_1(2,:) / (P_1(3,:) * X_j);
        (P_2(1,:)*X_j) * P_2(3,:) / (P_2(3,:)*X_j)^2 - P_2(1,:) / (P_2(3,:) * X_j);
        (P_2(2,:)*X_j) * P_2(3,:) / (P_2(3,:)*X_j)^2 - P_2(2,:) / (P_2(3,:) * X_j)];
[~ , r] = ComputeReprojectionError(P_1,P_2,X_j,x_1j,x_2j);
end

