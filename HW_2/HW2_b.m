clear all, clc, close all

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
E_syn = -50; 
global tau_syn
tau_syn = 1;

num_trials = 10; %number of spike trains generated to estimate firing rate
time_interval = 1000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_noise = 13.2;


%fix random seed:
rng('default');

spk_t = [200];


spk_output = synaptic_neuron(num_trials, 0, I_noise, spk_t, time_interval, 1);

% spk_times = zeros(num_trials, size(spk_output, 2));
% 
% %find times at which the spikes are non-zero
% for i=1:num_trials
%     i_times = find(spk_output(i, :));
%         %disp(i_times);
%     spk_times(i, 1:length(i_times)) = i_times;
% end
% 
% 
% raster_plot(spk_times*dt, time_interval);

