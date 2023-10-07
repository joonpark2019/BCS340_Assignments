
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
I_noise = 1; % [mA] --> use first current which causes non-zero firing or use a current which causes some degree of significant randomness??
time_interval = 10000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]
I_inj = 0;

%fix random seed:
rng('default');
fr_mean = 1/1000;
spks_r = regular_spk_train(fr_mean, time_interval);
spks_r_t = floor(spks_r / dt);
spikes_r = zeros(1, time_interval/dt);
spikes_r(spks_r_t) = 1;
spikes_r = spikes_r(1:time_interval/dt);

%% Sample test
figure();
t = dt:dt:time_interval;
plot(t, spikes_r);

avg_rate = mean(avg_fire_rate(num_trials, 0, I_noise, spks_r, time_interval));
disp(avg_rate);

targ_r = find_10hz_rate(8/1000, 50/1000, num_trials, I_noise, time_interval);
disp(targ_r);

function target_rate = find_10hz_rate(f_mean_min, f_mean_max, num_trials, I_noise, time_interval)
    tStart = tic;    
    search_interval = f_mean_min:(1/1000):f_mean_max;
    for rate = search_interval

        spks_r = regular_spk_train(rate, time_interval);

        %stochastic variable --> use meand and std_dev to judge whether
        %firing rate is 10 Hz
        rates = avg_fire_rate(num_trials, 0, I_noise, spks_r, time_interval);
        target_rate = rate;
        if 10 <= mean(rates) + std(rates) || mean(rates) + std(rates) <= 10
            disp(mean(rates));
            break
        end

        %enforce time limit on search
        tEnd = toc;
        if (tEnd - tStart > 120)
            
            break;
        end
    end

    
end



%% finding probability of a spike causing an output spike
% probs = calculate_spike_prob(1000, 0, I_noise);
% disp(probs);

% histogram = cross_correlogram(spks_norm, spks_noise);
% figure;
% stem(histogram);
