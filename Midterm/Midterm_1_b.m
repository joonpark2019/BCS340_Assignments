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

T = 0.1:0.1:1;    % times in seconds
T = 1000 * T;       % convert to ms

fano_factors = zeros(length(T), 1);


figure();
for i = 1:length(T)
    
    spks_point = poisson_spk_train_point(num_trials, p, T(i));
    % subplot(1, length(T), i);
    % stem(spks_point);
    rates_per_trial = sum(spks_point, 2)./(T(i) / 1000);
    fano_factor = std(rates_per_trial)^2 / mean(rates_per_trial);
    fano_factors(i) = fano_factor;
end
% 
% spks_point = poisson_spk_train_point(num_trials, p, time);
% rates_per_trial = sum(spks_point, 2)./(time / 1000);
% avg = mean(rates_per_trial);
% std_dev = std(rates_per_trial);
% disp(avg);
% disp(std_dev);
