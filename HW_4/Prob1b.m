clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 5 / 1000; % 5 Hz
time_len = 1000; % 1 second: 1000 ms
num_trials = 1000;
dt = 0.1;
spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt);

num_spks = sum(spk_outputs, 2);
[n_bins, prob_hist] = prob_rate(num_spks);

entropy = entropy_rate(prob_hist);
disp("Entropy (in bits):");
disp(entropy);