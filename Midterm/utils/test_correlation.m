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
%spks_point = poisson_spk_train_point(1, p, T);
% figure();
% stem(spks_1);
% hold on;
% stem(spks_2);

histogram = spk_correlogram(spk_times_1, spk_times_2, 500, 1, 1);

% correlalogram = correlation(spk_times_1, spk_times_2, T, 5);
% figure();
% % bar(correlalogram, 'r');
% stem(correlalogram);
%figure(1);
%stem(spks_isi(1,:));
%figure(2);
%stem(spks_point(1,:));





