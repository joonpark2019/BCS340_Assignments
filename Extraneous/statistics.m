
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

time_interval = 10000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_inj = 0;

%fix random seed:
rng('default');

noise_strength = 10;

%% colored noise: mean isi distribution:
% 
% noise_strength = 12;
% test_time = 10000; %ms
% spks = synaptic_neuron(10, 0, noise_strength, [], test_time, 0);
% isi_sample = dt * diff(find(spks));
% isi_sample = reshape(isi_sample.',1,[]);
% figure();  
% binSize = 1;                                            % 1 ms bins
% bins = 1:binSize:100;
% intervalDist = hist(isi_sample(isi_sample < 100), bins);
% intervalDist = intervalDist / sum(intervalDist) / binSize; % normalize by dividing by spike number
% %fit to lognormal distribution:
% pd = fitdist(transpose(isi_sample),'Lognormal');
% disp("Lognormal distribution:");
% disp(pd);
% disp("Mean:");
% disp(1000 / exp(pd.mu)); %rate in Hz
% disp("Min: ");
% disp(1000 / exp(pd.mu + pd.sigma)); %rate in Hz
% disp("Max: ");
% disp(1000 / exp(pd.mu - pd.sigma)); %rate in Hz
% y = pdf(pd,bins);
% 
% bar(bins, intervalDist);
% hold on
% plot(bins, y, 'r', 'LineWidth',2)
% hold off


%% poisson input:
fr_mean = 50/1000;
spk_input_p = poisson_spk_train(fr_mean, time_interval);
spk_input_r = regular_spk_train(fr_mean, time_interval);

%% taken from: https://www.hms.harvard.edu/bss/neuro/bornlab/nb204/statistics/poissonTutorial.txt
figure();                                              % use Figure 2
binSize = 1;                                            % 1 ms bins
x = 1:binSize:100;


I_noise = 10; % [mA]

%% Verifying the Poisson distribution:
spk_times = diff(spk_input_p);
intervalDist = hist(spk_times(spk_times < 100), x);
intervalDist = intervalDist / sum(intervalDist) / binSize; % normalize by dividing by spike number
bar(x, intervalDist);

y = exppdf(x, 1/fr_mean);            % exponential function, scaled to predicted max
axis([min(x) max(x) 0 max(y) * 1.1]);                   % make sure everything shows on the plot
xlabel('Interspike interval');
ylabel('Probability');
hold on;
plot(x, y, 'r');                                        % add exponential function 
hold off;


%% Giving the Poisson spike train as an input to a synaptic neuron (no noise):

spks_p = synaptic_neuron(1, 0, I_noise, flatten(spk_input_p), time_interval, 1);
isi_sample_p = dt * diff(find(spks_p));
isi_sample_p = reshape(isi_sample_p.',1,[]);
intervalDist_p = hist(isi_sample_p(isi_sample_p < 100), x);
intervalDist_p = intervalDist_p / sum(intervalDist_p) / binSize; % normalize by dividing by spike number
figure();
bar(x, intervalDist_p);

%% Giving a Regular spike train as an input to a synaptic neuron (no noise):


spks_r = synaptic_neuron(1, 0, I_noise, flatten(spk_input_r), time_interval, 1);
isi_sample_r = dt * diff(find(spks_r));
isi_sample_r = reshape(isi_sample_r.',1,[]);
intervalDist_r = hist(isi_sample_r(isi_sample_r < 100), x);
intervalDist_r = intervalDist_r / sum(intervalDist_r) / binSize; % normalize by dividing by spike number
figure();
bar(x, intervalDist_r);



%% use this function to unify all vectors into ROW vectors
function a = flatten(b)
    if sum(size(b) == [length(b), 1]) == 2
        a = b.';
    else
        a = b;
    end
end
