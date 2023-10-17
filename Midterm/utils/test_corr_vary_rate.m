clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

global dt
dt = 0.1;

%% Poisson Spike Generator
N = 1; % # of trials
T = 5000; % ms
r = 100; % # of spikes/s (constant) --> Hz
p = r/1000; % 1ms

t = dt:dt:T;
period = 0.1*1000; % [ms]
rates = (100/1000) + (50/1000).*cos(2*pi*(1/period)*t);
figure();
plot(t, rates);

spk_output = poisson_spk_train_vary(1, rates, T);
spk_times = dt*find(spk_output);
%spks_point = poisson_spk_train_point(1, p, T);
figure();
stem(spk_output);
% hold on;
% stem(spks_2);

figure();
histogram = spk_correlogram(spk_times, spk_times, 500, 1, 1);

% correlalogram = correlation(spk_times_1, spk_times_2, T, 5);
% figure();
% % bar(correlalogram, 'r');
% stem(correlalogram);
%figure(1);
%stem(spks_isi(1,:));
%figure(2);
%stem(spks_point(1,:));





