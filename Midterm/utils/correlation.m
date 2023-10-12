
%% cross correlation histogram
% inputs: two arrays with spk times in ms
% note: window time unit is ms, NOT indices
function hist_correlogram = correlation(spike_train1, spike_train2, time_window, bin_size)
    global dt;
    max_time = max(max(spike_train1), max(spike_train2));
    hist_correlogram = zeros(1, max_time/dt + floor(time_window / (2 * dt)));
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];
    histEdges = -time_window/2:bin_size:time_window/2;
    
    % Calculate spike time differences within the time window
    for t1 = spike_train1
        % find index locations in spike_train2 where difference against t1
        % is less than half the time_window
        logic_indices = abs(spike_train2 - t1) <= time_window/2;

        spk_2_range = spike_train2( logic_indices);

        time_diffs = spk_2_range - t1; %time difference against all spikes greater than the input spk --> assume causality
        histCounts = histcounts(time_diffs, histEdges);
        spk_indx = floor(t1/dt);
        min_indx = spk_indx - floor(time_window/(2 * dt));
        max_indx = spk_indx + floor(time_window/(2 * dt));
        disp(min_indx);
        disp(max_indx);
        if min_indx < 0
            min_indx = 1;
            hist_start_idx = 
        end
        disp(min_indx);
        hist_correlogram(min_indx:max_indx) = hist_correlogram(min_indx:max_indx) + histCounts;
        % spike_time_differences = [spike_time_differences, time_diffs];
    end
    
    % output the total number of spks in spike_train2 occurring within the time
    % window of spks in spike_train1
    % histEdges = -time_window/2:bin_size:time_window/2;
    % histCounts = histcounts(spike_time_differences, histEdges);

end %for any given spike, how many are within the time window??