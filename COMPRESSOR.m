function [P_out, T_out, w_c] = COMPRESSOR(pRatioC, compEff, P_in, T_in, R, y_c)
    %Calculating output pressure of Compressor by prusser ratio
    P_out = pRatioC .* P_in;

    %Calculating output T of Comperessor
    t_c = 1 + (pRatioC.^((y_c-1)./y_c) - 1)./compEff;
    T_out = t_c .* T_in;

    %Calculating work consumed by Compressor
    c_pc = y_c.*R ./ (y_c - 1);
    w_c = c_pc.*T_in .* (t_c - 1);
end