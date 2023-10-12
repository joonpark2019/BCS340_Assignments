clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

global dt
dt = 0.1;

%% Poisson Spike Generator
N = 100; % # of trials
T = 100; % ms
r = 100; % # of spikes/s (constant) --> Hz
p = r/1000; % 1ms


[spk_times_isi, spks_isi] = poisson_spk_train_isi(1, p, T);

spks_point = poisson_spk_train_point(1, p, T);

correlalogram = correlation(spks_isi, spks_point, 5, 1);

%figure(1);
%stem(spks_isi(1,:));
%figure(2);
%stem(spks_point(1,:));

