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

%Noise current found in part e)
I_noise = 1.6200; %[mA]

%The time interval was increased in order to improve precision:
time_interval = 5000; %[ms]


%fix random seed:
rng('default');



tic;
I_min = -0.1; %minimum current is set heuristically (an arbitrary negative current unlikely to cause firing)
I_max= 5;     %maximum current is also set heuristically

%% First, find Noise value at which neuron first starts to fire
I_test = I_min:0.001:I_max;
threshold_current = 0;
%iterate through range of test input current to find the threshold current
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, I_noise, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        threshold_current = i_input;
        disp("Threshold current [mA]:");
        disp(threshold_current);
        disp("Rate at initial current [Hz]:");
        disp(rate);
        break
    end
end


telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);
