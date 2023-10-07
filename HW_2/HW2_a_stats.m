
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
time_interval = 10000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_inj = 0;

%fix random seed:
rng('default');



%% colored noise: mean isi distribution:

noise_strength = 10;
test_time = 10000; %ms
spks = synaptic_neuron(10, 0, noise_strength, [], test_time, 0);
isi_sample = dt * diff(find(spks));
isi_sample = reshape(isi_sample.',1,[]);
figure();  
binSize = 1;                                            % 1 ms bins
bins = 1:binSize:100;
intervalDist = hist(isi_sample(isi_sample < 100), bins);
intervalDist = intervalDist / sum(intervalDist) / binSize; % normalize by dividing by spike number
%fit to lognormal distribution:
pd = fitdist(transpose(isi_sample),'Lognormal');
disp("Lognormal distribution:");
disp(pd);
disp("Mean:");
disp(1000 / exp(pd.mu)); %rate in Hz
disp("Min: ");
disp(1000 / exp(pd.mu + pd.sigma)); %rate in Hz
disp("Max: ");
disp(1000 / exp(pd.mu - pd.sigma)); %rate in Hz
y = pdf(pd,bins);

bar(bins, intervalDist);
hold on
plot(bins, y, 'r', 'LineWidth',2)
hold off
