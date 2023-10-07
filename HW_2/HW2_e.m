
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

num_trials = 10; %number of spike trains generated to estimate firing rate
I_noise = 1; % [mA] --> use first current which causes non-zero firing
time_interval = 10000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_inj = 0;

%fix random seed:
rng('default');

spk_input = poisson_spk_train(400/1000, time_interval);

spks_p_t = floor(transpose(spk_input) / dt);
spikes_p = zeros(1, time_interval/dt);
spikes_p(spks_p_t) = 1;
spikes_p = spikes_p(1:time_interval/dt);

figure();
t = dt:dt:time_interval;
plot(t, spikes_p);

avg_rate = mean(avg_fire_rate(num_trials, 0, I_noise, spk_input, time_interval));
disp(avg_rate);


%% finding probability of a spike causing an output spike
% probs = calculate_spike_prob(1000, 0, I_noise);
% disp(probs);

% histogram = cross_correlogram(spks_norm, spks_noise);
% figure;
% stem(histogram);
