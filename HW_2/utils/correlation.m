
%% cross correlation histogram
% inputs: two arrays with spk times in ms
% note: window time unit is ms, NOT indices
function histCounts = correlation(spike_train1, spike_train2, time_window)
    global dt;

 
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];
    
    % Calculate spike time differences within the time window
    for t1 = spike_train1
        % find index locations in spike_train2 where difference against t1
        % is less than half the time_window
        logic_indices = abs(spike_train2 - t1) <= time_window/2;

        spk_2_range = spike_train2( logic_indices);

        time_diffs = abs(spk_2_range - t1); %time difference against all spikes greater than the input spk --> assume causality
        
        spike_time_differences = [spike_time_differences, time_diffs];
    end
    
    % output the total number of spks in spike_train2 occurring within the time
    % window of spks in spike_train1
    histCounts = length(spike_time_differences);

end %for any given spike, how many are within the time window??