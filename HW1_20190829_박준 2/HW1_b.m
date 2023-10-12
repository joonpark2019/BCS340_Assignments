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
I_input = -0.9860; %[mA]
I_noise = 0; %[mA]
time_interval = 1000; %[ms]
I_min = 0; %[mA]
I_max= 5; %[mA]

%fix random seed:
rng('default');

tic;


%% First, find threshold current value at which neuron first starts to fire
I_test = I_min:0.01:I_max;
initial_current = 0;
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, 0, time_interval));
    if rate > 0
        % current at which neuron starts firing
        initial_current = i_input;
        disp("Threshold current [mA]:");
        disp(initial_current);
        disp("Rate at initial current [Hz]:");
        disp(rate);
        break
    end
end


%% Narrowing down the range for noise which causes 1Hz firing rate

%reduce the current from the threshold 
I_inputs = initial_current:-0.0001:0;
i_one_hz = 0;
for i_n=1:length(I_inputs)
    rate = mean(avg_fire_rate_conv(10, I_inputs(i_n), 0, time_interval));
    %disp(rate);
    if abs(rate - 1) < 0.1
        disp("rate [Hz]:");
        disp(rate);
        disp("Current for 1Hz firing rate [mA]:");
        disp(I_inputs(i_n));
        i_one_hz = I_inputs(i_n);
        break
    end
end

telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);
