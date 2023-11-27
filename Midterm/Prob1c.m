clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

%% Poisson Spike Generator
num_trials = 100;   % # of trials
time = 100;         % ms
rate = 800;          % # of spikes/s (average firing rate in Hz)
p = rate/1000;      % # of spikes/ms

T = 0.1:0.1:1;      % time in seconds
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
% stem(spks_point(1, :));

figure('Position', [50 50 1500 600])
plot(T, fano_factors);
title("Time Length vs. Fano Factor");
xlabel("Time Length of Trial (ms)");
ylabel("Fano Factor");
writematrix(fano_factors, 'fano_factos_100Hz.csv')
