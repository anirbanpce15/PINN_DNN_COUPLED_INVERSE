X = linspace(0,1,50);

% Create a figure window for all subplots
figure;

% First subplot (1st plot in the first row)
subplot(4,1,1);
load('PINN50Q05.mat');
plot(X, Swmean(1:end-1), 'k*--', 'LineWidth', 1);
ylabel('<S_w>');
title('f=0.5, q_{in}=0.5 m/d');

% Second subplot (2nd plot in the second row)
subplot(4,1,2);
load('PINNGM50Q95.mat');
plot(X, Swmean, 'k*--', 'LineWidth', 1);
ylabel('<S_w>');
title('f=0.5, q_{in}=0.95 m/d');

% Third subplot (3rd plot in the third row)
subplot(4,1,3);
load('PINN75Q7.mat');
plot(X, Swmean(1:end-1), 'k*--', 'LineWidth', 1);

title('f=0.75, q_{in}=0.7 m/d');

% Fourth subplot (4th plot in the fourth row)
subplot(4,1,4);
load('PINN90Q9MC.mat');
plot(X, Swmean(1:end-1), 'k*--', 'LineWidth', 1);
xlabel('X*');
ylabel('<S_w>');
title('f=0.9, q_{in}=0.9 m/d');

% Create a common legend outside the plots
% legend({'f=0.5, q_{in}=0.5 m/d', 'f=0.5, q_{in}=0.95 m/d', ...
%         'f=0.75, q_{in}=0.7 m/d', 'f=0.9, q_{in}=0.9 m/d'}, ...
%         'Orientation', 'horizontal', 'Position', [0.1, 0.95, 0.8, 0.05]);
% 
