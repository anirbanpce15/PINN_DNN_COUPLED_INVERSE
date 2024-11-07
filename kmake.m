% Parameters for the first lognormal distribution
mu1 = log(100);  % Mean of the first peak (logarithm of the desired mean)
sigma1 = 0.99;     % Standard deviation of the first peak

% Parameters for the second lognormal distribution
mu2 = log(120);  % Mean of the second peak (logarithm of the desired mean)
sigma2 = 0.8;      % Standard deviation of the second peak

% Create the lognormal distribution objects
dist1 = makedist('Lognormal', mu1, sigma1);
dist2 = makedist('Lognormal', mu2, sigma2);

% Define the mixing proportions
mixing_proportion = 0.5;  % Equal mixing proportions for simplicity

% Generate random samples from the mixture distribution
num_samples1 = round(50 * mixing_proportion);  % Number of samples for the first peak
num_samples2 = 50 - num_samples1;             % Number of samples for the second peak
samples1 = random(dist1, num_samples1, 1);
samples2 = random(dist2, num_samples2, 1);
samples = [samples1; samples2];

% Scale the samples to range from 10 to 10000
scaled_samples = exp(log(10) + (log(10000) - log(10)) * ((samples - min(samples)) / (max(samples) - min(samples))));

% Plot the histogram of the generated samples
histogram(scaled_samples, 'Normalization', 'probability');
xlabel('Value');
ylabel('Probability');
title('Bimodal Lognormal Distribution (10 to 10000)');
