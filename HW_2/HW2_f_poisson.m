
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
fr_max = 800/1000;

%fix random seed:
rng('default');


[response_p, x_range_p] = response_function_poisson(fr_min, fr_max);
%figure('Position', [50, 50, 1000, 900]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% poisson input:
spk_input_p = poisson_spk_train(fr_max, time_interval);

% creating a logical array to plot the input poisson spike
spikes_input_p = zeros(time_interval/dt, 1);
spikes_input_p(floor(spk_input_p / dt)) = 1;
spikes_input_p = spikes_input_p(1:time_interval/dt);

%% taken from: https://www.hms.harvard.edu/bss/neuro/bornlab/nb204/statistics/poissonTutorial.txt
%figure();                                              % use Figure 2
binSize = 1;                                            % 1 ms bins
x = 1:binSize:100;

%% Giving the Poisson spike train as an input to a synaptic neuron:

spks_p = synaptic_neuron(1, 0, I_noise, flatten(spk_input_p), time_interval, 0);
isi_sample_p = dt * diff(find(spks_p));
isi_sample_p = reshape(isi_sample_p.',1,[]);
intervalDist_p = hist(isi_sample_p(isi_sample_p < 100), x);
intervalDist_p = intervalDist_p / sum(intervalDist_p) / binSize; % normalize by dividing by spike number


figure();
subplot(1,2,1);
stem(spikes_input_p)
title("Input Poisson Spike Train")
xlabel('Time (ms)');
ylabel('Spike');
subplot(1,2,2);
stem(spks_p)
title("Output Poisson Spike Train")
xlabel('Time (ms)');
ylabel('Spike');


figure('Position', [50, 50, 1000, 900]);
subplot(1,2,1);
plot(1000*x_range_p(1:length(response_p)), response_p)
title("Poisson Input Spike Response Function")
xlabel('Average Input Spike Rate (Hz)');
ylabel('Fraction of Output Spikes within 0.4 ms of Input Spikes');

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
    time_window = 0.8;      % Time window in ms
    noise_strength = 5;     % Noise level in mA
    time_interval = 1000;   % Time interval for simulation in ms
    fr_range = fr_min:(5/1000):fr_max;
    sum_hist = [];
    
    for i=1:length(fr_range)
        spk_input_p = poisson_spk_train(fr_range(i), 1000);
        spk_input_p = flatten(spk_input_p);
        spks_p = synaptic_neuron(1, 0, noise_strength, spk_input_p, time_interval, 0);
        spk_output_p = dt*find(spks_p);
        spk_output_p = flatten(spk_output_p);
        % find fraction of output spikes within the time window of input
        % spikes
        fraction_corr = correlation(flatten(spk_input_p), spk_output_p, time_window) / length(spks_p);
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