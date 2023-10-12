
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
I_noise = 5; % [mA] 
time_interval = 10000; %[ms]

%fix random seed:
rng('default');

%% Showing results for a low input firing rate:
fr_low = 20/1000;
spks_p_low = poisson_spk_train(fr_low, time_interval);

% creating a logical array to plot the input poisson spike
spikes_p_low = zeros(time_interval/dt, 1);
spikes_p_low(floor(spks_p_low / dt)) = 1;
spikes_p_low = spikes_p_low(1:time_interval/dt);

binSize = 1;   % 1 ms bins
max_isi = 500; % 500 ms maximum isi
x = 1:binSize:max_isi;

spks_output_p_low = synaptic_neuron(1, 0, I_noise, spks_p_low, time_interval, 0);

subplot(1,3,1);
stem(spikes_p_low)
title("Input Poisson Spike Train")
xlabel('Time (ms)');
ylabel('Spike');
subplot(1,3,2);
stem(spks_output_p_low)
title("Output Poisson Spike Train")
xlabel('Time (ms)');
ylabel('Spike');

isi_sample_p_l = dt * diff(find(spks_output_p_low));
isi_sample_p_l = reshape(isi_sample_p_l.',1,[]);
intervalDist_p = hist(isi_sample_p_l(isi_sample_p_l < max_isi), x);
intervalDist_p = intervalDist_p / sum(intervalDist_p) / binSize; % normalize by dividing by spike number
subplot(1,3,3);
bar(x, intervalDist_p)

y = exppdf(x, 1/fr_low);            % exponential function, scaled to predicted max
axis([min(x) max(x) 0 max(y) * 1.1]);                   % make sure everything shows on the plot
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');
hold on
plot(x, y, 'r')                                       % add exponential function 
hold off



%% Showing results for a very high input firing rate:
fr_high = 500/1000; % a 500 Hz firing rate (500 spikes / 1000 ms)
spks_p = poisson_spk_train(fr_high, time_interval);

%turn the spks_p times into a logical array which can be plotted
spikes_p = zeros(time_interval/dt, 1);
spikes_p(floor(spks_p / dt)) = 1;
spikes_p = spikes_p(1:time_interval/dt);


% create output spikes by giving spks_p as input to a single neuron:
spks_output_p = synaptic_neuron(1, 0, I_noise, spks_p, time_interval, 0);

% Generate the ISI histogram:


binSize = 1;   % 1 ms bins
max_isi = 300; % 500 ms maximum isi
x = 1:binSize:max_isi;

isi_sample_p = dt * diff(find(spks_output_p));
isi_sample_p = reshape(isi_sample_p.',1,[]); %flatten the isi_sample_p into a column vector
intervalDist_p = hist(isi_sample_p(isi_sample_p < max_isi), x);
intervalDist_p = intervalDist_p / sum(intervalDist_p) / binSize; % normalize by dividing by spike number
figure();
bar(x, intervalDist_p);

% Poisson spike train follows an exponential distribution:
y = exppdf(x, 1/fr_high);            % exponential function, scaled to predicted max
axis([min(x) max(x) 0 max(y) * 1.1]);                   % make sure everything shows on the plot
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');
hold on
plot(x, y, 'r')                                       % add exponential function 
hold off

disp("Probability of ISI being within 1 ms:");
disp(intervalDist_p(1));

%% Heuristic achievement of 10 Hz firing rate:

fr_mean = 230/1000; % input spiking rate which causes an output rate of 10 Hz (rate measured as num spikes / time)
spks_input = poisson_spk_train(fr_mean, time_interval);
spk_output_10Hz = synaptic_neuron(1, 0, I_noise, spks_input, time_interval, 0);
isi_10Hz = dt * diff(find(spk_output_10Hz));

% the firing rate is determined by dividing the number of spikes by time,
% as there is no clear distribution in the ISI:
avg_rate = avg_fire_rate(num_trials, 0, I_noise, spks_input, time_interval);
disp("Closest output firing rate achieved near 10 Hz:");
disp(mean(avg_rate));

