
%% revised calculation for rate with gaussian:
function avg_rates = avg_fire_rate(n_trials, i_inj, i_noise, spk_input, time_len)
    global E_spike
    global dt

    % spk_times: a vector with 0's for non-spikes and 1's indicating spikes
    spk_times = synaptic_neuron(n_trials, i_inj, i_noise, spk_input, time_len, 0);

    for i=1:n_trials
        
        avg_frate = sum(spk_times(i, :)) / (time_len/1000);
        avg_rates(i) = avg_frate;

    end
    
end
