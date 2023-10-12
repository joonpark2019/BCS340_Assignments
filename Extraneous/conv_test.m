clc;
close all;
clear all;
spike_count = randi([0,30],100); % Random generated neural data: spike counts of 100 neurons (each row is a neuron) within 100 seconds(each column is a time bin). Time bin length: 1 second. Because the time bin is 1 second, spike_count also represents firing rate before smoothing.
sigma = 1; % I experimented different sigmas, but not sure if there is a more systematic way to decide sigma. Just put 1 here for convenience. 
gaussian_range = -3*sigma:3*sigma; % setting up Gaussian window
gaussian_kernel = normpdf(gaussian_range,0,sigma); % setting up Gaussian kernel
gaussian_kernel = gaussian_kernel/sum(gaussian_kernel);
smoothed_firingrate = conv2(spike_count,gaussian_kernel,'same'); % convolution
figure (1)
plot (spike_count(1,:)); % plot the first neuron in spike_count as an example
hold on
plot(smoothed_firingrate(1,:)); % plot also the first neuron in smoothed_firingrate as an example
legend('Firing rate before smoothing','Firing rate after smoothing');
hold off
