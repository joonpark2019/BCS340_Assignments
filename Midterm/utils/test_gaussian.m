clear all, clc, close all

% Define your spike train (for example, as a binary vector)
spike_train = [0 0 1 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0];

% Parameters for the Gaussian filter
sigma = 2;  % Standard deviation of the Gaussian filter
filter_length = 10;  % Length of the filter kernel (adjust as needed)

% Create the Gaussian filter kernel manually
t = -filter_length:filter_length;
filter_kernel = exp(-t.^2 / (2*sigma^2));
filter_kernel = filter_kernel / sum(filter_kernel);

% Apply the filter to the spike train using filtfilt()
filtered_spike_train = filtfilt(filter_kernel, 1, spike_train);

% Plot the original and filtered spike trains
figure;
subplot(2,1,1);
stem(spike_train, 'b', 'LineWidth', 1.5);
title('Original Spike Train');
xlabel('Time');
ylabel('Spike');

subplot(2,1,2);
stem(filtered_spike_train, 'r', 'LineWidth', 1.5);
title('Filtered Spike Train');
xlabel('Time');
ylabel('Filtered Spike');