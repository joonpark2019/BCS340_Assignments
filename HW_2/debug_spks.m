clear all, clc, close all

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

%% Parameter initialization:
time_interval = 1000; %1000 ms = 1s
fr_mean = 50/1000; %make 500 Hz input spike train

%% Generate regular and poisson spike trains:
spks_r = regular_spk_train(fr_mean, time_interval);
spks_p = poisson_spk_train(fr_mean, time_interval);
spks_p = floor(spks_p / dt);
spikes_p = zeros(1, time_interval/dt);
spikes_p(spks_p == 1) = 1;


t = dt:dt:time_interval;
% plot(t, spks_r);
figure();
plot(t, spks_p);