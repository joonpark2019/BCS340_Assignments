% input: 
% 1. n_trials: number of trials used to calculate the 
% 2. i_inj: injected noise from patch clamp (mA)
% 3. i_noise: noise input (mA)
% output:
% 1. probability of spike occurring after the input spike
function probs = calculate_spike_prob(n_trials, i_inj, i_noise)
    global dt;
    interval = 10; %[ms]: arbitrarily small 

    spk_input = [floor(interval / 2)]; %single spike input causing 
    start_idx = floor(interval / (2*dt)); %starting index for counting spikes

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