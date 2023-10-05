function probs = calculate_spike_prob(n_trials, i_inj, i_noise)
    global dt;
    interval = 10; %[ms]: arbitrary

    spk_input = [floor(interval / 2)]; %single spike input causing 
    %disp(spk_input);
    start_idx = floor(interval / (2*dt)); %starting index for counting spikes
    %disp(start_idx);
    spk_count = 0;

    %run for many iterations and find how many spikes occur within the
    %given time window
    for i=1:n_trials
        spks = synaptic_neuron(1, i_inj, i_noise, spk_input, interval, 0);
        %disp(length(spks));
        if ~isempty(find(spks(start_idx:end), 1))
            spk_count = spk_count + 1;
        end

    end

    probs = spk_count / n_trials;

end