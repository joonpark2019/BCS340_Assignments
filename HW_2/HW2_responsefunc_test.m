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
E_syn = 10; 
global tau_syn
tau_syn = 1;

num_trials = 1; %number of spike trains generated to estimate firing rate
I_noise = 13.28; % [mA]
time_interval = 1000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]

%fix random seed:
rng('default');


spk_t = [];

spk_first = synaptic_neuron(num_trials, I_max, I_noise, spk_t, time_interval,  0);

%find times at which the spikes are non-zero
for i=1:num_trials
    i_times = find(spk_first(i, :));
        %disp(i_times);
    spk_first(i, 1:length(i_times)) = i_times;
end

spk_second = synaptic_neuron(num_trials, I_max, I_noise, dt*spk_first, time_interval, 0);


spk_times = zeros(2, size(spk_first, 2));
i_times_first = find(spk_first(1, :));
spk_times(1, 1:length(i_times_first)) = i_times_first;
i_times_second = find(spk_second(1, :));
spk_times(2, 1:length(i_times_second )) = i_times_second;


raster_plot(spk_times*dt, time_interval);
corr = response_function(spk_first, spk_second);
disp(corr);

