
%% cross correlation histogram
% inputs: two 1xn spike trains --> both must have the same length
% note: window time unit is ms, NOT indices
function histCounts = correlation_histogram(spike_train1, spike_train2, time_window, bin_size)
    global dt;

    % Define two spike trains (as arrays of spike times)
    % spike_train1 = dt * find(spk_target);
    % spike_train2 = dt * find(spk_reference);
    
    
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];
    
    % Calculate spike time differences within the time window
    % code depends on everything having the same dimension!!
    for t1 = spike_train1
        logic_indices = abs(spike_train2 - t1) <= time_window/2;
        % disp("size logic indices:");
        % disp(size(logic_indices));
        spk_2_range = spike_train2( logic_indices);
        % disp("size spk_2_range indices:");
        % disp(size(spk_2_range));  
        %disp(size(spk_2_range));
        time_diffs = abs(spk_2_range - t1); %time difference against all spikes greater than the input spk --> assume causality
        %time_diffs = time_diffs(time_diffs <= time_window);
        
        spike_time_differences = [spike_time_differences, time_diffs];
    end
    
    % Create a histogram of spike time differences
    histEdges = 0:bin_size:time_window;
    histCounts = histc(spike_time_differences, histEdges);

end %for any given spike, how many are within the time window??