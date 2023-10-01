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

num_trials = 5;
I_input = 0;
I_noise = 0;
time_interval = 1000; %[ms]
min_current = -5; %[mA]
max_current = 30; %[mA]


%fix random seed:
rng('default');

I_noise_min = 0; %[mA]
I_noise_max= 5; %[mA]

%% Find first noise current value at which neuron first starts to fire
I_noise_test = I_noise_min:0.1:I_noise_max;
initial_current = 0;
for i_nse = I_noise_test
    rate = mean(avg_fire_rate_conv(10, 0, i_nse, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        initial_current = i_nse;
        disp("Initial Current Which Produces Firing (mA):");
        disp(initial_current);
        break
    end
end


%% Narrowing down the range for noise which causes 5Hz firing rate

%Set range of noise currents starting from the current found previously:
I_noise = i_nse:0.01:2.0;

%Find current at which 
inse_five_hz = 0;
for i_n=1:length(I_noise)
    rate = mean(avg_fire_rate_conv(10, 0, I_noise(i_n), time_interval));
    if abs(rate - 5) < 0.5
        disp("Rate Found (Hz):");
        disp(rate);
        disp("Noise current (mA):");
        disp(I_noise(i_n));
        inse_five_hz = I_noise(i_n);
        break
    end
end


%% Display spike train using a raster plot at which the average firing rate is 5 Hz
s_train = plot_conv(num_trials, 0, inse_five_hz, time_interval);
spk_times = zeros(num_trials, size(s_train, 2));
for i=1:num_trials
    i_times = find(s_train(i, :));
    %disp(i_times);
    spk_times(i, 1:length(i_times)) = i_times;
end

%a num_trials x spk_train length sized array
sptimes = spk_times*dt;

raster_plot(sptimes, time_interval);
