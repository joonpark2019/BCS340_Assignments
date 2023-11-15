
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

t = dt:dt:T;
period = 0.1*1000; % [ms]
rates = (100/1000) + (50/1000).*cos(2*pi*(1/period)*t);
figure();
plot(t, rates);

spk_output = poisson_spk_train_vary(1, rates, T);

figure()
autocorr(spk_output)

% 
% 
% [spk_times_1, spks_1] = poisson_spk_train_isi(1, p, T);
% [spk_times_2, spks_2] = poisson_spk_train_isi(1, p, T);
% spk_times_1 = spk_times_1(spk_times_1 > 0);
% spk_times_2 = spk_times_2(spk_times_2 > 0);
% 
% 
% 
% spk_indices_1 = floor(spk_times_1 / dt); 
% spk_train_1 = zeros(max(spk_indices_1), 1);
% spk_train_1(spk_indices_1) = 1;
% spk_indices_2 = floor(spk_times_2 / dt); 
% spk_train_2 = zeros(max(spk_indices_2), 1);
% spk_train_2(spk_indices_2) = 1;
