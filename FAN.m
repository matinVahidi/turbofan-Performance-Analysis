function [w_f, P_out, T_out] = FAN(alpha, fanEff, pRatioF, P_in, T_in, R, y_c)
    %Calculating output pressure of Fan by prusser ratio
    P_out = pRatioF .* P_in;

    %Calculating output T of Fan
    t_f = 1 + (pRatioF.^((y_c - 1)./y_c) - 1)./fanEff;
    T_out = t_f .* T_in;

    %Calculating work consumed by FAN
    c_pc = y_c .* R./(y_c - 1);
    w_f = alpha .* c_pc .* T_in .* (t_f - 1);
end