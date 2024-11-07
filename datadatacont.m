load('PINN90Q9MC.mat')

% Plot the data
plot(Swmeanerr, Swmean, 'x', Swmean, Swmean);

% Add a legend
legend('Contaminated data', '1:1');

% Set axis scaling to equal
axis equal;

% Set the limits for both axes
xlim([0 0.9]);
ylim([0 0.9]);
xlabel('True <S_w>')
ylabel('Contaminated <S_w>')

% Set the tick marks to ensure alignment
xticks(0:0.15:0.9);
yticks(0:0.15:0.9);