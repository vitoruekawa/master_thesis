clearvars; clc; close all;
load_vsm2axis_params;
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
u = [0, 0.1, 0.1, 0.1;...
     0,   0,   0,   0];

%% Scenario 4: SM in bus 2 is replaced by GFMI

values = [0, 0.5, 1, 5, 10, 50, 100];
omegas = cell(size(values));
figure1 = figure;
for idx = 1:length(values)
    Xq_prime = values(idx);

    ref_model_params.Xq_prime = Xq_prime;
    gfmi = gfmi_vsm_2axis(vsc_params,controller_params,ref_model_params);
    avr_gfmi = avr_sauer(avr_params);
    gfmi.set_avr(avr_gfmi);
    
    net = network_IEEE9bus();
    net.a_bus{2}.set_component(gfmi);
    net.initialize();
    out = net.simulate(time, u, u_idx);
    
    %% Load data
    t = out.t;
    omega = sqrt(out.V{2}(:, 1).^2 + out.V{2}(:, 2).^2);
    omegas{idx} = [t, omega];
    plot(t, omega, 'LineWidth', 8,'DisplayName', ['$Xq'' = ' num2str(Xq_prime) '$'])
    hold on
end

% xlabel('Time (s)', 'FontSize', 20,'FontWeight','bold') % x-label on the bottom-right subplot
% ylabel('Frequency (Hz)', 'FontSize',20,'FontWeight','bold') % y-label on the top-left subplot
grid on;set(gca,'fontsize',50);
% title("Frequency for difference of $X_q'$", 'FontSize', 20,'FontWeight','bold', 'Interpreter', 'latex')
legend('show', 'Location', 'best','Interpreter','latex'); % 'Location', 'best' will place the legend in the best location to avoid obscuring the data



% Define the axes for the inset plot
insetXRange = [0.998, 1.04]; % Define the x-axis range for the zoom

% Define the position of the inset plot on the figure
% [left bottom width height] in normalized units of the figure
insetPosition = [0.5, 0.5, 0.2, 0.3]; % Modify as needed for your figure

% Create the inset axes
axes('Position', insetPosition);
box on; % Optional: add a box around the inset plot

% Plot the same data in the inset
hold on;
for idx = 1:length(omegas)
    out = omegas{idx};
    % Assuming out.t and out.X{2}(:, 10) are available from the earlier simulation
    % You may need to re-run simulations or access stored data
    t = out(:,1);
    omega = out(:,2);
    
    % Filter the data for the zoom range
    zoomIndices = t >= insetXRange(1) & t <= insetXRange(2);
    tZoom = t(zoomIndices);
    omegaZoom = omega(zoomIndices);
    
    % Plot the zoomed data
    plot(tZoom, omegaZoom, 'LineWidth', 8);
end
hold off;
title('Zoomed-In View');

% Set the limits for the inset axes
xlim([0.998, 1.01]);
grid on;set(gca,'fontsize',50);
