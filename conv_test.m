clear; close all;

% Define your spike train (replace with your data)
spikeTrain = [0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]; % Example spike train

% Define a unit Gaussian curve
sigma = 1; % Standard deviation of the Gaussian
x = -5*sigma:0.01:5*sigma; % Range of x values
gaussianCurve = 1/(sqrt(2*pi)*sigma) * exp(-x.^2 / (2*sigma^2));

% Convolve spike train with the Gaussian curve using FFT
convolutionResult = ifft(fft(spikeTrain) .* fft(gaussianCurve, length(spikeTrain)));

% Plot the original spike train, Gaussian curve, and the convolution result
subplot(3,1,1);
stem(spikeTrain, 'r', 'filled');
title('Spike Train');

subplot(3,1,2);
plot(x, gaussianCurve, 'b');
title('Unit Gaussian Curve');

subplot(3,1,3);
plot(convolutionResult, 'g');
title('Convolution Result');

xlabel('Time');