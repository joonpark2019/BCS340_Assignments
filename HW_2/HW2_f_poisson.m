
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

I_noise = 5; % [mA] --> use first current which causes non-zero firing
time_interval = 1000; %[ms]
fr_min = 0;
fr_max = 900/1000;

%fix random seed:
rng('default');


[response_p, x_range_p] = response_function_poisson(fr_min, fr_max);
%figure('Position', [50, 50, 1000, 900]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% poisson input:
spk_input_p = poisson_spk_train(fr_max, time_interval);

%% taken from: https://www.hms.harvard.edu/bss/neuro/bornlab/nb204/statistics/poissonTutorial.txt
%figure();                                              % use Figure 2
binSize = 1;                                            % 1 ms bins
x = 1:binSize:100;

%% Giving the Poisson spike train as an input to a synaptic neuron (no noise):

spks_p = synaptic_neuron(1, 0, I_noise, flatten(spk_input_p), time_interval, 1);
isi_sample_p = dt * diff(find(spks_p));
isi_sample_p = reshape(isi_sample_p.',1,[]);
intervalDist_p = hist(isi_sample_p(isi_sample_p < 100), x);
intervalDist_p = intervalDist_p / sum(intervalDist_p) / binSize; % normalize by dividing by spike number

figure('Position', [50, 50, 1000, 900]);
subplot(1,2,1);
plot(1000*x_range_p(1:length(response_p)), response_p)
title("Poisson Input Spike Response Function")
xlabel('Average Input Spike Rate (Hz)');
ylabel('Number of Spikes within 1 ms of input spikes');

subplot(1,2,2);
bar(x, intervalDist_p)
y = exppdf(x, 1/fr_max);            % exponential function, scaled to predicted max
axis([min(x) max(x) 0 max(y) * 1.1]);                   % make sure everything shows on the plot
title("Inter Spike Interval Histogram")
xlabel('Interspike interval (1 ms bins)');
ylabel('Probability');
hold on
plot(x, y, 'r')                                       % add exponential function 
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [sum_hist, fr_range] = response_function_poisson(fr_min, fr_max)
    global dt;
    time_window = 2.0;  % Time window in ms
    bin_size = 0.1;     % Bin size in ms
    noise_strength = 5;
    time_interval = 1000;
    fr_range = fr_min:(5/1000):fr_max;
    sum_hist = [0];
    
    for i=1:length(fr_range)
        spk_input_p = poisson_spk_train(fr_range(i), 1000);
        spk_input_p = flatten(spk_input_p);
        spks_p = synaptic_neuron(1, 0, noise_strength, spk_input_p, time_interval, 0);
        spk_output_p = dt*find(spks_p);
        spk_output_p = flatten(spk_output_p);
        total_count = sum(correlation_histogram(flatten(spk_input_p), spk_output_p, time_window, bin_size));
        %disp(total_count);
        %disp(size(total_count));
        sum_hist = [sum_hist, total_count];
        
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