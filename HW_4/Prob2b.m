clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 20 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 5;
spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt);

% num_spks = sum(spk_outputs, 2);
% [n_bins, prob_hist] = prob_rate(num_spks);


%% plot both on on the same histogram:
figure();
imagesc(spk_outputs);
title("Spike Train Outputs (#Trials x # Time Bines)")
xlabel("Number of Time Bins (5 ms interval)")
ylabel("Number of Trials")
colormap = "gray";
colorbar()

