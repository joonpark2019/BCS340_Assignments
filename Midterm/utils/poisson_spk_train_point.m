% Creates a Poisson spike train with average firing rate of fr_mean
%input: 
% - fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% - time: length of spike train in ms
%output: 
% - spk_output: logical indices for whether a spike occurs of not
function spk_output = poisson_spk_train_point(n_trials, fr_mean, time)
    dt = 1; %ms

    % uses a point process to create spikes:
    % each time event is independent : at each point, a spike is created
    % if a probability is less than the mean firing rate
    spk_output = rand(n_trials, floor(time/dt)) < (fr_mean * dt);
end