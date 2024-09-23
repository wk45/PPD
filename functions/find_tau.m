function tau_prctile = find_tau(t, f, pt, displayFlag)

    if nargin < 4
            displayFlag = false;
    end

    % Calculate the time difference
    diff_t = mean(diff(t));
    taus = [];
    
    % Compute tau values
    for i = 1:size(f, 1)
        idx = islocalmax(f(i,:));
        df2 = gradient(gradient(f(i,:), diff_t), diff_t);
        tau = -df2 / max(-df2);
        taus = [taus, tau(idx)];
    end

    tau_prctile = prctile(taus, pt * 100);
    % If displayFlag is true, plot the cumulative distribution
    if displayFlag
        % Sort tau2 for plotting
        x = sort(taus);
        y = linspace(0, 1, length(taus));
        plot(x, y, 'LineWidth', 1.5)
        hold on
        
        % Add a vertical line at the percentile value
        xline(tau_prctile, 'r:', 'LineWidth', 1.5)
        
        % Annotate the plot with quantile information
        y_position = 0.9;  % Adjust y position for text annotation
        text(tau_quantile + 0.015, y_position, sprintf('\\tau = %.3f', tau_quantile), 'Color', 'k', 'fontsize', 15)
        
        % Set plot limits and labels
        xlim([x(1), x(end)])
        xlabel('$\tau$', 'interpreter', 'latex')
        ylabel('Cumulative Probability', 'interpreter', 'latex')
        set(gca, 'fontsize', 15)
        
        hold off
    end
end

