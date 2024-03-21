function [P, Q] = calculate_power(V, I)
    Vcomplex = V(:,1) + 1j * V(:,2);
    Icomplex = I(:,1) + 1j * I(:,2);
    Pow = Vcomplex .* conj(Icomplex);
    P = real(Pow); Q = imag(Pow);
end