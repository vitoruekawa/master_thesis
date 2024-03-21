clearvars; clc; close all;
load_vsm_params;
Te = 0.314; Ke = 1; 
Ta = 0.2  ; Ka = 20;
Tf = 0.35 ; Kf = 0.063;
avr_params = table(Te, Ke, Ta, Ka, Tf, Kf);

%% Simulation an plot parameters
t_final = 10;
x_lim = [0, t_final];
y_lim = [-inf, inf];
plot_separated = true;

time = [0, 1 , 5, t_final];
u_idx = 8;
u = [0, 0.4, 0.4, 0.4;...
     0, 0, 0, 0];

% time = [0, 1, 2, t_final];
% u_idx = 8;
% u = [0, -1,   -1,   -1;...
%      0, -1,   -1,   -1];

%% Scenario 1: all machines are SM
% net = network_IEEE9bus();
% out = net.simulate(time, u, u_idx);

%% Scenario 2: SM in bus 2 is replaced by GFMI
load_vsm_params;
gfmi1 = gfmi_vsm_classical(vsc_params,controller_params,ref_model_params);
avr_gfmi1 = avr_sauer(avr_params);
gfmi1.set_avr(avr_gfmi1);

net1 = network_IEEE9bus();
net1.a_bus{2}.set_component(gfmi1);
net1.initialize();
out1 = net1.simulate(time, u, u_idx);

%% Scenario 3: SM in bus 2 is replaced by GFMI
load_vsm_params;
gfmi2 = gfmi_vsm_1axis(vsc_params,controller_params,ref_model_params);
avr_gfmi2 = avr_sauer(avr_params);
gfmi2.set_avr(avr_gfmi2);

net2 = network_IEEE9bus();
net2.a_bus{2}.set_component(gfmi2);
net2.initialize();
out2 = net2.simulate(time, u, u_idx);

%% Scenario 4: SM in bus 2 is replaced by GFMI
% ref_model_params.Xd_prime = 0.2;
gfmi3 = gfmi_vsm_2axis(vsc_params,controller_params,ref_model_params);
avr_gfmi3 = avr_sauer(avr_params);
gfmi3.set_avr(avr_gfmi3);

net3 = network_IEEE9bus();
net3.a_bus{2}.set_component(gfmi3);
net3.initialize();
out3 = net3.simulate(time, u, u_idx);

%% Load data
% omega1 = out.X{1}(:, 2) / (2 * pi);
% omega2 = out.X{2}(:, 2) / (2 * pi);
% omega3 = out.X{3}(:, 2) / (2 * pi);

omega11 = out1.X{1}(:, 2) / (2 * pi);
omega12 = out1.X{2}(:, 10) / (2 * pi);
omega13 = out1.X{3}(:, 2) / (2 * pi);

omega21 = out2.X{1}(:, 2) / (2 * pi);
omega22 = out2.X{2}(:, 10) / (2 * pi);
omega23 = out2.X{3}(:, 2) / (2 * pi);

omega31 = out3.X{1}(:, 2) / (2 * pi);
omega32 = out3.X{2}(:, 10) / (2 * pi);
omega33 = out3.X{3}(:, 2) / (2 * pi);

omega = {
    % [out.t, omega1, omega2, omega3];
    [out1.t, omega11, omega12, omega13];
    [out2.t, omega21, omega22, omega23];
    [out3.t, omega31, omega32, omega33];
};

% V1 = vecnorm(out.V{1}, 2, 2);
% V2 = vecnorm(out.V{2}, 2, 2);
% V3 = vecnorm(out.V{3}, 2, 2);

V11 = vecnorm(out1.V{1}, 2, 2);
V12 = vecnorm(out1.V{2}, 2, 2);
V13 = vecnorm(out1.V{3}, 2, 2);

V21 = vecnorm(out2.V{1}, 2, 2);
V22 = vecnorm(out2.V{2}, 2, 2);
V23 = vecnorm(out2.V{3}, 2, 2);

V31 = vecnorm(out3.V{1}, 2, 2);
V32 = vecnorm(out3.V{2}, 2, 2);
V33 = vecnorm(out3.V{3}, 2, 2);

voltages = {
    % [out.t, V1, V2, V3];
    [out1.t, V11, V12, V13];
    [out2.t, V21, V22, V23];
    [out3.t, V31, V32, V33];
};

% I1 = vecnorm(out.I{1}, 2, 2);
% I2 = vecnorm(out.I{2}, 2, 2);
% I3 = vecnorm(out.I{3}, 2, 2);

I11 = vecnorm(out1.I{1}, 2, 2);
I12 = vecnorm(out1.I{2}, 2, 2);
I13 = vecnorm(out1.I{3}, 2, 2);

I21 = vecnorm(out2.I{1}, 2, 2);
I22 = vecnorm(out2.I{2}, 2, 2);
I23 = vecnorm(out2.I{3}, 2, 2);

I31 = vecnorm(out3.I{1}, 2, 2);
I32 = vecnorm(out3.I{2}, 2, 2);
I33 = vecnorm(out3.I{3}, 2, 2);

currents = {
    % [out.t, I1, I2, I3];
    [out1.t, I11, I12, I13];
    [out2.t, I21, I22, I23];
    [out3.t, I31, I32, I33];
};

% [P1, Q1] = calculate_power(out.V{1}, out.I{1});
% [P2, Q2] = calculate_power(out.V{2}, out.I{2});
% [P3, Q3] = calculate_power(out.V{3}, out.I{3});

[P11, Q11] = calculate_power(out1.V{1}, out1.I{1});
[P12, Q12] = calculate_power(out1.V{2}, out1.I{2});
[P13, Q13] = calculate_power(out1.V{3}, out1.I{3});

[P21, Q21] = calculate_power(out2.V{1}, out2.I{1});
[P22, Q22] = calculate_power(out2.V{2}, out2.I{2});
[P23, Q23] = calculate_power(out2.V{3}, out2.I{3});

[P31, Q31] = calculate_power(out3.V{1}, out3.I{1});
[P32, Q32] = calculate_power(out3.V{2}, out3.I{2});
[P33, Q33] = calculate_power(out3.V{3}, out3.I{3});

P = {
    % [out.t, P1, P2, P3];
    [out1.t, P11, P12, P13];
    [out2.t, P21, P22, P23];
    [out3.t, P31, P32, P33];
};

Q = {
    % [out.t, Q1, Q2, Q3];
    [out1.t, Q11, Q12, Q13];
    [out2.t, Q21, Q22, Q23];
    [out3.t, Q31, Q32, Q33];
};

generate_plot(omega, 'Frequency(Hz)')
generate_plot(voltages, 'Voltage Magnitude (pu)')
generate_plot(currents, 'Current Magnitude (pu)')
generate_plot(P, 'Active Power (pu)')
generate_plot(Q, 'Reactive Power (pu)')