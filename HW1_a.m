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

num_trials = 10; %number of spike trains generated to estimate firing rate
I_noise = 0; % [mA]
time_interval = 1000; %[ms]
I_min = 0; % [mA]
I_max= 5; % [mA]

%fix random seed:
rng('default');


tic;


%% First, find Noise value at which neuron first starts to fire
I_test = I_min:0.1:I_max;
initial_current = 0;
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, 0, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        initial_current = i_input;
        disp("Threshold current [mA]:");
        disp(initial_current);
        disp("Rate at initial current [Hz]:");
        disp(rate);
        break
    end
end


%% Narrowing down the range for noise which causes 20Hz firing rate
I_inputs = initial_current:0.001:2.0;
i_twenty_hz = 0;

%Iterate through currents and check if the rate is within 0.5 Hz of the target 20 Hz
for i_n=1:length(I_inputs)
    rate = mean(avg_fire_rate_conv(10, I_inputs(i_n), 0, time_interval));

    %Check for rate:
    if abs(rate - 20) < 0.5
        disp("rate:");
        disp(rate);
        disp("Current for 20Hz firing rate:");
        disp(I_inputs(i_n));
        i_twenty_hz = I_inputs(i_n);
        break
    end
end


%% Plot raster plot for 20 Hz:

%generate the spike trains while also plotting the rates for all 10 trials
s_train = plot_conv(num_trials, i_twenty_hz, 0, time_interval);
spk_times = zeros(num_trials, size(s_train, 2));

%create all of the 
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


