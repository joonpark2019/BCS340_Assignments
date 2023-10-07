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
time_interval = 1000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_inj = 0;

%fix random seed:
rng('default');


[response_r, x_range_r] = response_function_reg(0, 900/1000);
figure();
plot(x_range_r(1:length(response_r)), response_r);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sum_hist, fr_range] = response_function_reg(fr_min, fr_max)
    global dt;
    time_window = 2.0;  % Time window in ms
    bin_size = 0.1;     % Bin size in ms
    noise_strength = 5;
    time_interval = 1000;
    fr_range = fr_min:(5/1000):fr_max;
    sum_hist = [0];
    
    for i=1:length(fr_range)
        spk_input_r = regular_spk_train(fr_range(i), 1000);
        spk_input_r = flatten(spk_input_r);
        spks_r = synaptic_neuron(1, 0, noise_strength, spk_input_r, time_interval, 0);
        spk_output_r = dt*find(spks_r);
        spk_output_r = flatten(spk_output_r);
        total_count = sum(correlation_histogram(flatten(spk_input_r), spk_output_r, time_window, bin_size));
        %disp(size(total_count));
        sum_hist = [sum_hist, total_count];
        
    end

end

%% use this function to unify all vectors into ROW vectors
function a = flatten(b)
    if sum(size(b) == [length(b), 1]) == 2
        a = b.';
    else
        a = b;
    end
end