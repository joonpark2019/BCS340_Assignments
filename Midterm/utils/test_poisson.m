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

t_start_isi = tic;   
[spk_times_isi, spks_isi] = poisson_spk_train_isi(N, p, T);
t_end_isi = toc;
t_start_point = tic;   
spks_point = poisson_spk_train_point(N, p, T);
t_end_point = toc;
disp(t_end_isi - t_start_isi);
disp(t_end_point - t_start_point);
disp("Size of isi spk train:");
disp(size(spks_isi));
disp("Size of point spk train:");
disp(size(spks_point));

figure(1);
stem(spks_isi(3,:));
figure(2);
stem(spks_point(1,:));

