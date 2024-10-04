clear;
clc;
close all;


M_0 = 0.85; %mach number of flight
alttitude = 10000; %alttitude of flight in m
y_c = 1.4;  %specfic thermal ratio of cold air
y_h = 1.25; %specfic thermal ratio of hot air
R = 287;    %universal gas constant
g = 9.81;   %gravity constant

%Prussere ratio of diffrent parts
pRatioD = 0.97;
pRatioF = 1.5;
pRatioFN = 0.98;
pRatioLPC = 4.2;
pRatioHPC = 7.5;
pRatioB = 0.95;
pRatioCN = 0.99;


%Efficency of diffrent parts
fanEff = 0.9;
LPcompEff = 0.87;
HPcompEff = 0.85;
combustorThermalEff = 0.99;
LPTshaftEff = 0.995;
LPturbineEff = 0.94;
HPTshaftEff =  0.993;
HPturbineEff = 0.92;

%Bypass to core air flow ratio
alpha = 8;

%Output tempreture of combustion chamber
T_t4 = 1400; %Kelvin

%Free air T and P
[T_0, ~, P_0] = atmosisa(alttitude);

%Fuel Thermal Value
h_f = 43;
h_f = h_f * 10^6; %j/kg


[P_t2, T_t2] = Diffuser(pRatioD, alttitude, M_0, y_c);
[w_f, P_t1_3, T_t1_3] = FAN(alpha, fanEff, pRatioF, P_t2, T_t2, R, y_c);
[u_1_9, P_1_9, T_1_9] = NOZZLE(pRatioFN, P_t1_3, T_t1_3, y_c, P_0, R, y_c);
[P_t2_5, T_t2_5, w_lpc] = COMPRESSOR(pRatioLPC, LPcompEff, P_t2, T_t2, R, y_c);
[P_t3, T_t3, w_hpc] = COMPRESSOR(pRatioHPC, HPcompEff, P_t2_5, T_t2_5, R, y_c);
[f, P_t4] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_t4, T_t3, P_t3, R, y_h, y_c);
[P_t4_5, T_t4_5] = TURBINE(HPTshaftEff, HPturbineEff, w_hpc, f, T_t4, P_t4, R, y_h);

w_lpt = w_lpc + w_f;
[P_t5, T_t5] = TURBINE(LPTshaftEff, LPturbineEff,  w_lpt, f, T_t4_5, P_t4_5, R, y_h);
[u_9, P_9, T_9] = NOZZLE(pRatioCN, P_t5, T_t5, y_h, P_0, R, y_c);


%Free air velocity
u_0 = M_0 .* sqrt(y_c.*R.*T_0);

%Specfic force produced by Fan
F_fan = alpha.*((u_1_9 - u_0) + R.*T_1_9.*(1-P_0./P_1_9)./u_1_9);

%Specfic force produced by core motor
F_core = (1+f).*((u_9 - u_0) + R.*T_9.*(1-P_0./P_9)./u_9);

%Specfic force of turbofan
F_turbofan = F_core + F_fan;

%Specfic fuel consumption
SFC = f./F_turbofan;

%Specfic motor trust
I_sp = F_turbofan.*g./f;

%Trust Efficiency of motor
n_p = F_turbofan.*u_0 ./ (0.5.*((1+f).*u_9.^2 + alpha.*u_1_9.^2 - (1+f).*u_0.^2));


%Ratio of F_fan and F_core to whole
 figure(1);
 plt = pie([F_fan F_core]);
 title('ّFan and Core engine share of produced Force');
 legend("F_{fan}", "F_{core}");



%%How Specfic Turbofan Trust will change with change of alpha
alpha = 4:0.1:14;

[P_t2, T_t2] = Diffuser(pRatioD, alttitude, M_0, y_c);
[w_f, P_t1_3, T_t1_3] = FAN(alpha, fanEff, pRatioF, P_t2, T_t2, R, y_c);
[u_1_9, P_1_9, T_1_9] = NOZZLE(pRatioFN, P_t1_3, T_t1_3, y_c, P_0, R, y_c);
[P_t2_5, T_t2_5, w_lpc] = COMPRESSOR(pRatioLPC, LPcompEff, P_t2, T_t2, R, y_c);
[P_t3, T_t3, w_hpc] = COMPRESSOR(pRatioHPC, HPcompEff, P_t2_5, T_t2_5, R, y_c);
[f, P_t4] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_t4, T_t3, P_t3, R, y_h, y_c);
[P_t4_5, T_t4_5] = TURBINE(HPTshaftEff, HPturbineEff, w_hpc, f, T_t4, P_t4, R, y_h);

w_lpt = w_lpc + w_f;
[P_t5, T_t5] = TURBINE(LPTshaftEff, LPturbineEff,  w_lpt, f, T_t4_5, P_t4_5, R, y_h);
[u_9, P_9, T_9] = NOZZLE(pRatioCN, P_t5, T_t5, y_h, P_0, R, y_c);


u_0 = M_0 * sqrt(y_c*R*T_0);

F_fan = alpha.*((u_1_9 - u_0) + R.*T_1_9.*(1-P_0./P_1_9)./u_1_9);

F_core = (1+f).*((u_9 - u_0) + R.*T_9.*(1-P_0./P_9)./u_9);

F_turbofan = F_core + F_fan;

figure(2);
set(gcf, 'Position', [200, 200, 800, 500]);
plot(alpha, F_turbofan);
title('Specfic Turbofan Trust changes with alpha', 'FontSize', 16);
xlabel('\alpha');
ylabel('F_{turbofan}');



%%How I_sp and F_turbofan will change with change of pRatioLPC
alpha = 8;
pRatioHPC = 4:0.1:24;

[P_t2, T_t2] = Diffuser(pRatioD, alttitude, M_0, y_c);
[w_f, P_t1_3, T_t1_3] = FAN(alpha, fanEff, pRatioF, P_t2, T_t2, R, y_c);
[P_t2_5, T_t2_5, w_lpc] = COMPRESSOR(pRatioLPC, LPcompEff, P_t2, T_t2, R, y_c);
[P_t3, T_t3, w_hpc] = COMPRESSOR(pRatioHPC, HPcompEff, P_t2_5, T_t2_5, R, y_c);
[f, P_t4] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_t4, T_t3, P_t3, R, y_h, y_c);
[P_t4_5, T_t4_5] = TURBINE(HPTshaftEff, HPturbineEff, w_hpc, f, T_t4, P_t4, R, y_h);

w_lpt = w_f + w_lpc;
[P_t5, T_t5] = TURBINE(LPTshaftEff, LPturbineEff,  w_lpt, f, T_t4_5, P_t4_5, R, y_h);
[u_9, P_9, T_9] = NOZZLE(pRatioCN, P_t5, T_t5, y_h, P_0, R, y_c);

u_0 = M_0 .* sqrt(y_c.*R.*T_0);

F_fan = alpha.*((u_1_9 - u_0) + R.*T_1_9.*(1-P_0./P_1_9)./u_1_9);

F_core = (1+f).*((u_9 - u_0) + R.*T_9.*(1-P_0./P_9)./u_9);

F_turbofan = F_core + F_fan;

SFC = f./F_turbofan;

I_sp = F_turbofan./f;

figure(3);
set(gcf, 'Position', [300, 200, 700, 500]);
title('I_{sp} and F_{turbofan} changes with \pi_{HPC}', 'FontSize', 14);
yyaxis left;
plot(pRatioHPC, I_sp);
xlabel('\pi_{HPC}');
ylabel('I_{sp}');

 
yyaxis right;
plot(pRatioHPC, F_turbofan);
ylabel('F_{turbofan}');
legend('I_{sp}', 'F_{turbofan}', 'Location','east');



%%How Specfic Turbofan Trust will chang with changes of Mach number and
%%alttitude
pRatioHPC = 7.5;
M_0 = 0.1:0.01:1; 

figure(4);
hold on;


for alttitude = 5000:5000:30000
    [T_0, ~, P_0] = atmosisa(alttitude);

    [P_t2, T_t2] = Diffuser(pRatioD, alttitude, M_0, y_c);
    [w_f, P_t1_3, T_t1_3] = FAN(alpha, fanEff, pRatioF, P_t2, T_t2, R, y_c);
    [u_1_9, P_1_9, T_1_9] = NOZZLE(pRatioFN, P_t1_3, T_t1_3, y_c, P_0, R, y_c);
    [P_t2_5, T_t2_5, w_lpc] = COMPRESSOR(pRatioLPC, LPcompEff, P_t2, T_t2, R, y_c);
    [P_t3, T_t3, w_hpc] = COMPRESSOR(pRatioHPC, HPcompEff, P_t2_5, T_t2_5, R, y_c);
    [f, P_t4] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_t4, T_t3, P_t3, R, y_h, y_c);
    [P_t4_5, T_t4_5] = TURBINE(HPTshaftEff, HPturbineEff, w_hpc, f, T_t4, P_t4, R, y_h);
    
    w_lpt = w_lpc + w_f;
    [P_t5, T_t5] = TURBINE(LPTshaftEff, LPturbineEff,  w_lpt, f, T_t4_5, P_t4_5, R, y_h);
    [u_9, P_9, T_9] = NOZZLE(pRatioCN, P_t5, T_t5, y_h, P_0, R, y_c);
    
    u_0 = M_0 .* sqrt(y_c.*R.*T_0);
    
    F_fan = alpha.*((u_1_9 - u_0) + R.*T_1_9.*(1-P_0./P_1_9)./u_1_9);
    
    F_core = (1+f).*((u_9 - u_0) + R.*T_9.*(1-P_0./P_9)./u_9);
    
    F_turbofan = F_core + F_fan;
    
    SFC = f./F_turbofan;
    
    plot(M_0, SFC);
end

figure(4);
title('SFC to Mach number for diffrent Alttitudes', 'FontSize', 16);
set(gcf, 'Position', [300 200 800 500]);
legend('5 km', '10 km', '', '','',  '15 to 30 km');
ylabel('SFC');
xlabel('Mach');
hold off;



%%SFC and f per changes of Mach number
alltitude = 10000;
[T_0, ~, P_0] = atmosisa(alttitude);


[P_t2, T_t2] = Diffuser(pRatioD, alttitude, M_0, y_c);
[w_f, P_t1_3, T_t1_3] = FAN(alpha, fanEff, pRatioF, P_t2, T_t2, R, y_c);
[u_1_9, P_1_9, T_1_9] = NOZZLE(pRatioFN, P_t1_3, T_t1_3, y_c, P_0, R, y_c);
[P_t2_5, T_t2_5, w_lpc] = COMPRESSOR(pRatioLPC, LPcompEff, P_t2, T_t2, R, y_c);
[P_t3, T_t3, w_hpc] = COMPRESSOR(pRatioHPC, HPcompEff, P_t2_5, T_t2_5, R, y_c);
[f, P_t4] = COMBUSTOR(pRatioB, combustorThermalEff, h_f, T_t4, T_t3, P_t3, R, y_h, y_c);
[P_t4_5, T_t4_5] = TURBINE(HPTshaftEff, HPturbineEff, w_hpc, f, T_t4, P_t4, R, y_h);

w_lpt = w_lpc + w_f;
[P_t5, T_t5] = TURBINE(LPTshaftEff, LPturbineEff,  w_lpt, f, T_t4_5, P_t4_5, R, y_h);
[u_9, P_9, T_9] = NOZZLE(pRatioCN, P_t5, T_t5, y_h, P_0, R, y_c);


u_0 = M_0 .* sqrt(y_c.*R.*T_0);
    
F_fan = alpha.*((u_1_9 - u_0) + R.*T_1_9.*(1-P_0./P_1_9)./u_1_9);
    
F_core = (1+f).*((u_9 - u_0) + R.*T_9.*(1-P_0./P_9)./u_9);
    
F_turbofan = F_core + F_fan;
    
SFC = f./F_turbofan;

 
figure(5);
title('SFC and f per changes of Mach number');
yyaxis left;
plot(M_0, SFC);
xlabel('M_0');
ylabel('SFC');
 
yyaxis right;
plot(M_0, f);
ylabel('f');

legend('SFC', 'f');

