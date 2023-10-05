function spk_output = regular_spk_train(fr_mean, time)
    global dt
    
    
    num_spks = time * fr_mean;
    period = floor((1/fr_mean));
    spk_times = period * ones(1, num_spks);
    spk_times = cumsum(spk_times);

    spk_output = spk_times;

    % spk_output = zeros(1, floor(time/dt));
    % spk_output(spk_times) = 1;

end