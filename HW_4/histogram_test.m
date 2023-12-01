close all, clc, clear all;
% Generate some sample data
data = randn(100, 10);

% Number of histograms
numHistograms = size(data, 2);

% Create a figure
figure;

% Use the parula colormap
colormap(parula(numHistograms));

hold on;

for i = 1:numHistograms
    % Extract data for the current histogram
    currentData = data(:, i);
    
    % Define histogram properties
    edges = linspace(min(currentData), max(currentData), 20);
    
    % Plot the histogram with transparency
    histogram(currentData, edges, 'EdgeAlpha', 0, 'FaceAlpha', 0.5);
end

hold off;

% Add legend
legend('Histogram 1', 'Histogram 2', 'Histogram 3', 'Histogram 4', 'Histogram 5', 'Histogram 6', 'Histogram 7', 'Histogram 8', 'Histogram 9', 'Histogram 10');

% Add labels and title
xlabel('X-axis Label');
ylabel('Frequency');
title('Overlayed Semi-Transparent Histograms');