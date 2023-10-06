
%% cross correlation histogram
% inputs: two 1xn spike trains --> both must have the same length
% note: window time unit is ms, NOT indices
function histCounts = cross_correlogram(spk_target, spk_reference)
    global dt;

    % Define two spike trains (as arrays of spike times)
    spike_train1 = dt * find(spk_target);
    spike_train2 = dt * find(spk_reference);
    
    % Set the time window and bin size for the histogram
    time_window = 5.0;  % Time window in ms
    bin_size = 0.3;     % Bin size in ms
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];
    
    % Calculate spike time differences within the time window
    for t1 = spike_train1
        time_diffs = abs(spike_train2 - t1);
        time_diffs = time_diffs(time_diffs <= time_window);
        spike_time_differences = [spike_time_differences, time_diffs];
    end
    
    % Create a histogram of spike time differences
    histEdges = 0:bin_size:time_window;
    histCounts = histcounts(spike_time_differences, histEdges);

end