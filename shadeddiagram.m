upper_bound = log(kemean) + 0.3 * log(stder);
lower_bound = log(kemean) - 0.3 * log(stder);

% Ensure X, upper_bound, and lower_bound are column vectors
X = X(:); % Convert X to column vector
upper_bound = upper_bound(:); % Convert upper_bound to column vector
lower_bound = lower_bound(:); % Convert lower_bound to column vector

% Check if they have the same size
if length(X) == length(upper_bound) && length(X) == length(lower_bound)
    % Create the shaded region with more transparency (FaceAlpha = 0.2)
    fill([X; flipud(X)], [upper_bound; flipud(lower_bound)], 'r', 'FaceAlpha', 0.4, 'EdgeColor', 'none');
    hold on;

    % Plot the mean line
     plot(X, log(kemean), 'r-', 'LineWidth', 2);

    % Plot the actual values
    plot(X, log(k_act(1:50)), 'b--', 'LineWidth', 2);

    hold off;

    % Add labels and title as needed
    xlabel('X*');
    ylabel('ln(k) [mD]');
     ylim([0 10])
     
     legend('Shaded Std Dev', 'Mean', 'Actual', 'Location', 'Best');
else
    error('X, upper_bound, and lower_bound must have the same length.');
end
