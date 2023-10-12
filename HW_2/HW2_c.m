
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
E_syn = -35; 
global tau_syn
tau_syn = 1;

I_noise = 15; % [mA] : slightly stronger noise than that determined in part a
time_interval = 10; %[ms]

%fix random seed:
rng('default');

spk_input = [floor(time_interval / 2)]; %single spike input at midpoint of the time interval

%% Comparing spikes with noise against spikes without noise
spks_norm = synaptic_neuron(1, 0, 0, spk_input, time_interval, 1);
spks_noise = synaptic_neuron(1, 0, I_noise, spk_input, time_interval, 1);

%% finding probability of a spike causing an output spike
% run 1000 trials and determine fraction of the trials where an output
% spike occurred near the input spike
probs = calculate_spike_prob(1000, 0, I_noise);
disp("Probability of a spike:");
disp(probs);
