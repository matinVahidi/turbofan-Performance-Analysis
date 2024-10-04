function [P_out, T_out] = TURBINE(shaftEff, turbineEff, w_c, f, T_in, P_in, R, y_h)
    %Calculating output T of Turbine
    c_ph = y_h.*R ./ (y_h - 1);
    T_out = T_in - w_c./(shaftEff .* (1 + f) .* c_ph);

    %Calculating output P of Turbine
    t_turb = T_out./T_in;
    pRatioT = (1 - (1 - t_turb)./turbineEff).^(y_h./(y_h - 1));
    

    %Effect of Turblacity
    P_out = pRatioT .* P_in;
end