
%% cross correlation histogram
% inputs: two arrays with spk times in ms
% note: window time unit is ms, NOT indices
function hist_correlogram = correlation(spike_train1, spike_train2, time_window, bin_size)
    global dt;
    
    % Initialize an array to store spike time differences
    spike_time_differences = [];

    % bug: length of histEdges is different from length of 
    histEdges = -time_window/2:bin_size:time_window/2;

    hist_len = length(histEdges) + 1;

    %correlogram length: (time_wind / 2)+(length_spike_train) + (time_wind
    %/ 2)
    hist_correlogram = zeros(1, corr_len + hist_len );
    hist_start = ceil(hist_len/2);
    hist_end = corr_len + ceil(hist_len/2);

    min_time = min(spike_train1);
    max_time = max(spike_train1);

    
    % Calculate spike time differences within the time window
    for t1 = spike_train1
        % find index locations in spike_train2 where difference against t1
        % is less than half the time_window
        logic_indices = abs(spike_train2 - t1) <= time_window/2;
        spk_2_range = spike_train2( logic_indices);

        time_diffs = spk_2_range - t1; %time difference against all spikes greater than the input spk --> assume causality
        histCounts = histcounts(time_diffs, histEdges);

        % spk_index: reference index which is the center of the histogram
        % time window
        
        % spk_indx = ceil(t1/bin_size) + floor(hist_len / 2);
        % min_indx = spk_indx - floor(hist_len / 2);
        min_indx = ceil(t1/bin_size);
        % if mod(hist_len / 2, 2) > 0 %%length is not divisible by two
        %     max_indx = spk_indx + floor(hist_len/2) + 1;
        % else
        %     max_indx = spk_indx + floor(hist_len/2);
        % end
        

        % if t1 == min_time && 
        %     spk_indx = hist_start;
        % elseif t1 == max_time
        %     spk_indx = hist_end;
        % end
        
        

        % for debugging display:
        % disp(min_indx + length(histCounts) - 1);
        hist_correlogram(min_indx:min_indx + length(histCounts) - 1) = hist_correlogram(min_indx:min_indx + length(histCounts) - 1) + histCounts;
        
        % spike_time_differences = [spike_time_differences, time_diffs];
    end
    hist_correlogram = hist_correlogram / length(hist_correlogram);
    
    % output the total number of spks in spike_train2 occurring within the time
    % window of spks in spike_train1
    % histEdges = -time_window/2:bin_size:time_window/2;
    % histCounts = histcounts(spike_time_differences, histEdges);

end %for any given spike, how many are within the time window??