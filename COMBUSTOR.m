function [f, P_out] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_out, T_in, P_in, R, y_h, y_c)
    %Calculating cp of gas for high and low temprture
    c_ph = y_h.*R ./ (y_h-1);
    c_pc = y_c.*R ./ (y_c-1);

    %Pressure reduction
    P_out = pRatioB .* P_in;

    %Calculating Fuel consumption of Turbine
    f = (c_ph.*T_out - c_pc.*T_in) ./ (combustorThermalEff.*h_f - c_ph.*T_out);
end