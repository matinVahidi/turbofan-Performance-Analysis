function [u_out, P_out, T_out] = NOZZLE(pRatioFN, P_in, T_in, y, P_0, R, y_c)
    %Calculating output pressure of Nozzle by prusser ratio
    P_mid = pRatioFN .* P_in;
  
    %Checking if Fan Nozzle if chocked or not
    if P_mid >= P_0 .* (y./2 + 0.5).^(y./(y-1))
        M_out = 1;
        P_out = P_mid./(y./2 + 0.5).^(y./(y-1));
    else
        P_out = P_0;
        M_out = sqrt(2*((P_mid./P_out).^((y-1)/y) - 1)./(y_c - 1));
    end
    
    %Calculating output T and velocity of Nozzle
    T_out = T_in;
    T_out = T_out ./ (1 + (y-1).*M_out.^2 ./ 2);
    u_out = M_out .* sqrt(y.*R.*T_out);
end