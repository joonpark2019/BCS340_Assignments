clear; close all; 

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

%% Testing Convolution:
% tic;
% %no noise:
% response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
% % hold on;
% % response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
% telapsed = toc;
% disp("time elapsed (s):");
% disp(telapsed);


tic;
I_min = -0.1;
I_max= 5;

%% First, find Noise value at which neuron first starts to fire
I_test = I_min:0.001:I_max;
threshold_current = 0;
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, I_noise, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        threshold_current = i_input;
        disp("Threshold current:");
        disp(threshold_current);
        disp("Rate at initial current:");
        disp(rate);
        break
    end
end


%% Trying to plot raster plot for lowest achievable firing rate:

s_train = plot_conv(num_trials, threshold_current, I_noise, time_interval);
spk_times = zeros(num_trials, size(s_train, 2));
for i=1:num_trials
    i_times = find(s_train(i, :));
    %disp(i_times);
    spk_times(i, 1:length(i_times)) = i_times;
end

%a num_trials x spk_train length sized array
sptimes = spk_times*dt;

raster_plot(sptimes, time_interval);

telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);
