clear all, clc, close all

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
I_noise = 3; %[mA]

%The time interval was increased in order to improve precision:
time_interval = 5000; %[ms]


%fix random seed:
rng('default');

figure(1);
response(-1, 5, I_noise);
hold on;
response(-1, 5, 0);

function response(i_min, i_max, i_noise)
    global dt

    i_inj = i_min:0.1:i_max;
    f_rates = zeros(length(i_inj), 1);
    for i=1:length(i_inj)
        spks = spike_generator_stochastic(10, i_inj(i), 5000, i_noise);
        % disp(size(sum(transpose(spks))));
        f_rates(i) = mean(sum(transpose(spks))) / 5000;
    end

    
    plot(i_inj,f_rates);
    if i_noise > 0
        title("With Noise");
    end

end