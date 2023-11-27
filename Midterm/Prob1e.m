clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

global dt
dt = 1;

%% Poisson Spike Generator
N = 100; % # of trials
T = 100; % ms
r = 10; % # of spikes/s (constant) --> Hz
p = r/1000; % 1ms

disp("%%%%%%%%%% Generation using ISI %%%%%%%%%%%%%%%");
tic;
[spk_times_isi, spks_isi] = poisson_spk_train_isi(N, p, T);
toc;

disp("%%%%%%%%%% Generation using Point %%%%%%%%%%%%%%%");
tic;
spks_point = poisson_spk_train_point(N, p, T);
toc;
t_end_point = toc;

