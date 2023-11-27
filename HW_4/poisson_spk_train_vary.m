% Creates a Poisson spike train with spike count equal to num_spks
%input: fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% time: length of spike train in ms
%output: times for spikes in ms ex) [0 50 100 .....]
function spk_output = poisson_spk_train_vary(n_trials, r, time)
    global dt;

    % spk_output = rand(n_trials, floor(time/dt)) < (fr_mean * dt);
    time_len = length(dt:dt:time);
    spk_output = zeros(n_trials, time_len);
    
    for trial = 1:n_trials
        spk= zeros(1, time_len); % initialize
        for t = 1:time_len
            if r(t) > dt*rand(1)
                spk(t) = 1;
            end
        end
        spk_output(trial, :) = spk;
    end


end