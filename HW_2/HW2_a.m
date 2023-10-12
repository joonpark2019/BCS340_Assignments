
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

%fix random seed:
rng('default');

%% colored noise: very high noise strengtht to illustrate fit to lognormal distribution

noise_strength_high = 50; % high noise current used
test_time = 10000; %ms
spks_test = synaptic_neuron(10, 0, noise_strength_high, [], test_time, 0);
isi_sample_test = dt * diff(find(spks_test));
isi_sample_test = reshape(isi_sample_test.',1,[]);
figure();  
binSize = 1;                                            % 1 ms bins
bins = 1:binSize:100;
intervalDist_test = hist(isi_sample_test(isi_sample_test < 100), bins);
intervalDist_test = intervalDist_test / sum(intervalDist_test) / binSize; % normalize by dividing by spike number
%fit to lognormal distribution:
pd = fitdist(transpose(isi_sample_test),'Lognormal');
disp("Lognormal distribution:");
disp(pd);
disp("Mean firing rate (Hz) for high test current:");
% rate is calculated as 1 / avg(ISI). For a lognormal distribution
% parameterized by mu, sigma, the mean of the distribution is e^mu. 
disp(1000 / exp(pd.mu)); %rate in Hz
y = pdf(pd,bins);

bar(bins, intervalDist_test);
hold on
plot(bins, y, 'r', 'LineWidth',2)
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');
hold off

%% noise which causes an average firing rate of around 5 Hz

noise_strength = 10; % noise current factor causing an average 5 Hz firing rate
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
disp("Mean firing Rate (Hz):");
% rate is calculated as 1 / avg(ISI). For a lognormal distribution
% parameterized by mu, sigma, the mean of the distribution is e^mu. 
disp(1000 / exp(pd.mu));        %rate in Hz
y = pdf(pd,bins);

bar(bins, intervalDist);
hold on
plot(bins, y, 'r', 'LineWidth',2)
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');
hold off

