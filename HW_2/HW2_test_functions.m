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
global E_syn %[mV]
E_syn = 10; 
global tau_syn
tau_syn = 1;

num_trials = 10; %number of spike trains generated to estimate firing rate
I_noise = 0; % [mA]
time_interval = 100; %[ms]
I_min = 0; % [mA]
I_max= 1; % [mA]

%fix random seed:
rng('default');


spk_t = [];

spk_output = synaptic_neuron(num_trials, I_max, spk_t, time_interval, I_noise);

gau_sdf = conv2(spk_output(1,:),gausswin(5),'same');
figure;
t = 1:time_interval/dt;
plot(t*dt, gau_sdf);

spk_times = zeros(num_trials, size(spk_output, 2));
    
%find times at which the spikes are non-zero
for i=1:num_trials
    i_times = find(spk_output(i, :));
        %disp(i_times);
    spk_times(i, 1:length(i_times)) = i_times;
end

raster_plot(spk_times*dt, time_interval);
