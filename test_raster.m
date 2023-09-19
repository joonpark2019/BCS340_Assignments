clear; close all; clf;

% Example spike train data (replace this with your data)
spikeTrains = rand(10, 100) < 0.1;  % Random binary data (0 or 1)

% Create a raster plot
[rowIndices, timeIndices] = find(spikeTrains);

% Plot spikes as dots on a grid
figure;
scatter(timeIndices, rowIndices, 10, 'k', 'filled');  % Adjust 'k' for color and 'filled' for filled markers

% Set plot properties
xlabel('Time');
ylabel('Neuron');
title('Raster Plot');
ylim([0.5, size(spikeTrains, 1) + 0.5]);  % Set the y-axis limits to match the number of rows
grid on;

% Optionally, invert the y-axis to display the top row at the top
set(gca, 'YDir', 'reverse');

% Optionally, customize plot appearance further
% For example, you can adjust marker size, color, etc.