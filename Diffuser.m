function [P_out, T_out] = Diffuser(pRatioD, alttitude, mach, y_c)
    %finding prussere and temperture of static atmospher in that alttitude
    [T_0, ~, P_0] = atmosisa(alttitude);

    %Calculating P and T for dynamic air
    T_1 = T_0 .* (1 + (mach.^2).*(y_c - 1)/2);
    P_1 = P_0 .* (1 + (mach.^2).*(y_c - 1)/2).^(y_c/(y_c - 1));

    %P and T reduction due to turbulance effect
    T_out = T_1;
    P_out = pRatioD .* P_1;
end