clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

global dt
dt = 0.1;

%% Poisson Spike Generator
N = 1; % # of trials
T = 100000; % ms
r = 100; % # of spikes/s (constant) --> Hz
p = r/1000; % 1ms


[spk_times_1, spks_1] = poisson_spk_train_isi(1, p, T);
[spk_times_2, spks_2] = poisson_spk_train_isi(1, p, T);
spk_times_1 = spk_times_1(spk_times_1 > 0);
spk_times_2 = spk_times_2(spk_times_2 > 0);

histogram = spk_correlogram(spk_times_1, spk_times_2, 500, 1, 1);






