% Creates a Poisson spike train with spike count equal to num_spks
%input: fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% time: length of spike train in ms
%output: times for spikes in ms ex) [0 50 100 .....]
function spk_output = poisson_spk_train_point(n_trials, fr_mean, time)
    global dt;
    spk_output = rand(n_trials, floor(time/dt)) < (fr_mean * dt);
end