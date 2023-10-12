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

time_interval = 1000;   %[ms]
fr_min = 0;             %spikes/ms
fr_max = 800/1000;      %spikes/ms
I_noise = 5;            %[mA]

binSize = 1;                                            % 1 ms bins
x = 1:binSize:100;

%fix random seed:
rng('default');

spk_input_r = regular_spk_train(fr_max, time_interval);

spks_r = synaptic_neuron(1, 0, I_noise, flatten(spk_input_r), time_interval, 0);
isi_sample_r = dt * diff(find(spks_r));
isi_sample_r = reshape(isi_sample_r.',1,[]);
intervalDist_r = hist(isi_sample_r(isi_sample_r < 100), x);
intervalDist_r = intervalDist_r / sum(intervalDist_r) / binSize; % normalize by dividing by spike number


[response_r, x_range_r] = response_function_reg(fr_min, fr_max);
figure('Position', [50, 50, 1000, 900]);
subplot(1,2,1);
plot(1000*x_range_r(1:length(response_r)), response_r);
title("Regular ISI Spike Response Function")
xlabel('Input Spike Rate (Hz)');
ylabel('Fraction of Output Spikes within 0.4 ms of Input Spikes');

subplot(1,2,2);
bar(x, intervalDist_r);
title("Inter Spike Interval Histogram at Input Firing Rate = 800 Hz")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sum_hist, fr_range] = response_function_reg(fr_min, fr_max)
    global dt;
    time_window = 0.8;    % Time window in ms
    noise_strength = 5;   % Noise level in mA
    time_interval = 1000; % Time interval for simulation in ms
    fr_range = fr_min:(5/1000):fr_max;
    sum_hist = [];
    
    for i=1:length(fr_range)
        spk_input_r = regular_spk_train(fr_range(i), 1000);
        spk_input_r = flatten(spk_input_r);
        spks_r = synaptic_neuron(1, 0, noise_strength, spk_input_r, time_interval, 0);
        spk_output_r = dt*find(spks_r);
        spk_output_r = flatten(spk_output_r);
        % find fraction of output spikes within the time window of input
        % spikes
        fraction_corr = correlation(flatten(spk_input_r), spk_output_r, time_window) / length(spks_r);
        sum_hist = [sum_hist, fraction_corr];
        
    end

end

%% use this function to unify all vectors into ROW vectors
function a = flatten(b)
    if sum(size(b) == [length(b), 1]) == 2
        a = b.';
    else
        a = b;
    end
end