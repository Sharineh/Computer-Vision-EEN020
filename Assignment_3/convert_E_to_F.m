function F = convert_E_to_F(E,K1,K2)
%CONVERT_E_TO_F Summary of this function goes here
%   Detailed explanation goes here
F = (K2')^-1 * E * K1^-1;
end

