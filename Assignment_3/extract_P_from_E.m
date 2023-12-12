function soul = extract_P_from_E(E)
%EXTRACT_P_FROM_E Summary of this function goes here
%   Detailed explanation goes here
[U , ~ , V ] = svd(E);
W = [0 -1 0; 1 0 0 ; 0 0 1];
if det(U*V') < 0
    V = -V;
end
R1 = U * W * V';
R2 = U * W' * V';
soul1 = [R1  U(:,3)]  / R1(end);
soul2 = [R1 -U(:,3)] / R1(end);
soul3 = [R2  U(:,3)]  / R2(end);
soul4 = [R2 -U(:,3)] / R2(end);
soul = {soul1,soul2,soul3,soul4};
end

