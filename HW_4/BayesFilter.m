clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate_estimate = 5 / 1000; % 5 Hz
time_len = 1000; % 1 second: 1000 ms
num_trials = 10;

avg_N = avg_frate_estimate* time_len;
n = 1:1:1000; %fix n
poisson_prior = (avg_N.^n.*exp(1).^(-1*avg_N))./factorial(n);
bel = poisson_prior;
avg_N_estimate = avg_N;

for i=1:num_trials
    % create a single spike train sequentially - in an actual animal trial,
    % this corresponds to giving the number of recorded spikes as an input
    spk_outputs = poisson_spk_train_point(1, avg_frate, time_len, dt);
    num_spks = sum(spk_outputs);
    
    %% update the belief using Bayes rule
    

end


% must add proof that the given method works better