clear; clc; close all; 

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

num_trials = 10;
I_noise = 0; %[mA]
time_interval = 10000; %[ms]
I_min = 0; %[mA] : a minimum current at which the neuron does not fire (determined heuristically)
I_max= 5; %[mA]  : a maximal current at which the 


%fix random seed:
rng('default');

tic;


%% First, find Noise value at which neuron first starts to fire
I_test = I_min:0.001:I_max;
initial_current = 0;
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, 0, time_interval));
    if rate > 0
        %first threshold current which causes a non-zero firing rate
        initial_current = i_input;
        disp("Threshold current [mA]:");
        disp(initial_current);
        disp("Rate at threshold current [Hz]:");
        disp(rate);
        break
    end
end


telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);

