
%% cross correlation histogram
% inputs: 
% - spike_train1, spike_train2: two arrays with spk times in ms
% - time_window, bin_size [ms]: 
%       histogram is in range (-time_window/2,time_window/2), with
%       increments of bin_size
% - plot_flg: if 1, plot histogram
% note: window time unit is ms, NOT indices
function hist_correlogram = spk_correlogram(spike_train1, spike_train2, time_window, bin_size, plot_flg)
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];

    hist_edges = -time_window/2:bin_size:time_window/2;
    
    % Calculate spike time differences within the time window
    for t1 = spike_train1
        % find index locations in spike_train2 where difference against t1
        % is less than half the time_window
        logic_indices = abs(spike_train2 - t1) <= time_window/2;
        spk_2_range = spike_train2( logic_indices);

        time_diffs = spk_2_range - t1;
        spike_time_differences = [spike_time_differences, time_diffs];
        
    end
    hist_correlogram = histcounts(spike_time_differences, hist_edges);
    hist_correlogram = hist_correlogram;

    if plot_flg
        bar(hist_edges(1:end-1), hist_correlogram, 'hist');
        xlabel('Time Difference (ms)');
        ylabel('Count');
        title('Spike Correlation Histogram');
    end



end