clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

global dt
dt = 1;

%% Poisson Spike Generator
num_trials = 100; % # of trials
time = 100; % ms
rate = 10; % # of spikes/s (constant) --> Hz
p = rate/1000; % 1ms

  
spks_point = poisson_spk_train_point(num_trials, p, time);
rates_per_trial = sum(spks_point, 2)./(time / 1000);
avg = mean(rates_per_trial);
std_dev = std(rates_per_trial);
disp(avg);
disp(std_dev);
