function out = generate_plot(data, y_title)
    %% Plot
    colorPalette = [
        0, 0.4470, 0.7410;  % MATLAB's default blue
        0.8500, 0.3250, 0.0980; % MATLAB's default orange
        0.9290, 0.6940, 0.1250; % MATLAB's default yellow
        0.4940, 0.1840, 0.5560; % MATLAB's default purple
    ];
    lineStyles = {'-', '--', ':', '-.'};

    out1 = data{1};
    out2 = data{2};
    out3 = data{3};
    % out4 = data{4};

    out = figure;
    out.Position = [0, 0, 1280, 1440];

    % Define line styles and colors for clarity
    
    % Subplot 1
    subplot(3, 1, 1)
    p1 = plot(out1(:,1), out1(:,2), 'LineWidth', 4, 'LineStyle', lineStyles{1}, 'Color', colorPalette(1,:));
    hold on
    p2 = plot(out2(:,1), out2(:,2), 'LineWidth', 4, 'LineStyle', lineStyles{2}, 'Color', colorPalette(2,:));
    hold on
    p3 = plot(out3(:,1), out3(:,2), 'LineWidth', 4, 'LineStyle', lineStyles{3}, 'Color', colorPalette(3,:));
    hold on
    % p4 = plot(out4(:,1), out4(:,2), 'LineWidth', 2, 'LineStyle', lineStyles{4}, 'Color', colorPalette(4,:));
    grid on;set(gca,'fontsize',30);
    
    % Subplot 2
    subplot(3, 1, 2)
    plot(out1(:,1), out1(:,3), 'LineWidth', 4, 'LineStyle', lineStyles{1}, 'Color', colorPalette(1,:))
    hold on
    plot(out2(:,1), out2(:,3), 'LineWidth', 4, 'LineStyle', lineStyles{2}, 'Color', colorPalette(2,:))
    hold on
    plot(out3(:,1), out3(:,3), 'LineWidth', 4, 'LineStyle', lineStyles{3}, 'Color', colorPalette(3,:))
    hold on
    % plot(out4(:,1), out4(:,3), 'LineWidth', 2, 'LineStyle', lineStyles{4}, 'Color', colorPalette(4,:))
    grid on;set(gca,'fontsize',30);

    % Subplot 3
    subplot(3, 1, 3)
    plot(out1(:,1), out1(:,4), 'LineWidth', 4, 'LineStyle', lineStyles{1}, 'Color', colorPalette(1,:))
    hold on
    plot(out2(:,1), out2(:,4), 'LineWidth', 4, 'LineStyle', lineStyles{2}, 'Color', colorPalette(2,:))
    hold on
    plot(out3(:,1), out3(:,4), 'LineWidth', 4, 'LineStyle', lineStyles{3}, 'Color', colorPalette(3,:))
    hold on
    % plot(out4(:,1), out4(:,4), 'LineWidth', 2, 'LineStyle', lineStyles{4}, 'Color', colorPalette(4,:))
    grid on;set(gca,'fontsize',30);


    % Set common labels
    % xlabel(subplot(3, 1, 3), 'Time (s)', 'FontSize', 30,'FontWeight','bold') % x-label on the bottom-right subplot
    % ylabel(subplot(3, 1, 2), y_title, 'FontSize',30,'FontWeight','bold') % y-label on the top-left subplot
    
    % Set individual titles if needed
    % title(subplot(3, 1, 1), 'Bus 1', 'FontSize', 30,'FontWeight','bold')
    % title(subplot(3, 1, 2), 'Bus 2', 'FontSize', 30,'FontWeight','bold')
    % title(subplot(3, 1, 3), 'Bus 3', 'FontSize', 30,'FontWeight','bold')
    
    % Legend
    L = legend([p1 p2 p3], {'Scenario 1', 'Scenario 2', 'Scenario 3'}, 'FontSize',30, 'Orientation','horizontal', 'Location', 'southoutside');
    set(L, 'Position', [0.46, 0.001, 0.1, 0.1], 'Units', 'normalized'); % Adjust as needed
    set(L, 'Box', 'off'); % Turn off the box surrounding the legend
end