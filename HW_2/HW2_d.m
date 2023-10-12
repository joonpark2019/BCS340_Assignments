
clear all, clc, close all

 addpath(genpath("./utils"));

%% Setting some constants and initial values

%setting as global variables to be used in the spike generator
global E_rest
E_rest = -65; % resting potential [mV]
global tau
tau = 20; % time constant [ms]
global dt
dt=0.1; % integration time step [ms]
global R
R = 10; %resistance(Ohms)
global E_thresh
E_thresh = -55; %threshold voltage for spikes [mV]
global E_spike %[mV]
E_spike = 10;
global E_syn %[mV]
E_syn = 0; 
global tau_syn
tau_syn = 1;

num_trials = 10;                % number of spike trains generated to estimate firing rate
I_noise = 5;                    % [mA]: use a noise level which causes non-negligible stochasticity but does not dominate the ISI statistics
time_interval = 10000;          %[ms]


%fix random seed:
rng('default');

%% Generate Input Spike Train
fr_mean = 10/1000;                                      % 10 Hz input rate (10 spikes / 1000 ms)
spks_r = regular_spk_train(fr_mean, time_interval);     % Input spike train with regular ISI

%% Test which shows that output also has regular ISI

spks_test = synaptic_neuron(1, 0, I_noise, spks_r, time_interval, 0);

%% Create histogram of ISI:
% Note: result shows a strong peak at 100 ms, which corresponds to a
% regular 10 Hz output spike train
binSize = 1;   % 1 ms bins
max_isi = 500; % 500 ms maximum isi
x = 1:binSize:max_isi;

spks_output_r = synaptic_neuron(1, 0, I_noise, spks_r, time_interval, 1);
isi_sample_r = dt * diff(find(spks_output_r));
isi_sample_r = reshape(isi_sample_r.',1,[]);
intervalDist_r = hist(isi_sample_r(isi_sample_r < max_isi), x);
intervalDist_r = intervalDist_r / sum(intervalDist_r) / binSize; % normalize by dividing by spike number
figure();
bar(x, intervalDist_r);
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');