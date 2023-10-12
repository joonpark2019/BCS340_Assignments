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

num_trials = 10;      %number of spike trains generated to estimate firing rate
time_interval = 1000; %[ms]
I_noise = 0;          %No noise given as input


%fix random seed:
rng('default');

%% A spike input at the 200 ms mark is given as a stimulus
spk_t = [200];

%% Visualization of the response to the spike input with zero noise
spk_output = synaptic_neuron(num_trials, 0, I_noise, spk_t, time_interval, 1);


