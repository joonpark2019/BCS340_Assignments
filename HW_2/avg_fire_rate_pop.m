
%% revised calculation for rate with gaussian:
function avg_rates = avg_fire_rate_pop(n_trials, I, I_n, spk_input, time)
    global E_spike
    global dt

    % spk_times: a vector with 0's for non-spikes and 1's indicating spikes
    spk_times = synaptic_neuron(n_trials, I, spk_input, time, I_n);
    disp(length(spk_times));

    %create a gaussian kernel:
    sigma = 1;

    
    % binsize = 5 * dt; % in seconds, so everything else should be seconds too
    % gauss_window = 1./binsize; % 1 ms window
    % gauss_SD = 1./binsize; % 0.02 seconds (20ms) SD
    % gk = gausskernel(gauss_window,gauss_SD); gk = gk./binsize; % normalize by binsize


    window_len = 1/dt;
    width_factor = (window_len - 1) / (2 * sigma);
    gk = gausswin(window_len, width_factor); gk = gk * 1/(sqrt(2*pi)*sigma);
    t_win = dt:dt:1;
    t = dt:dt:time;

    figure('Position', [50, 50, 1000, 900]);
    subplot(n_trials+1,1,1);
    plot(t_win, gk);
    xlabel('Time (ms)', 'FontSize', 7);
    ylabel('Firing Rate (Hz)', 'FontSize', 7);
    title("Filter plot");

    start_time = randn*time;

    for i=1:n_trials
        % spk_train = s_p(i, :);
        % s_times = find(s(i, :));
        % if isempty(s_times) || (length(s_times) == 1 && s_times(1) == 1)
        %     avg_rates(i) = 0;
        % else
        %     conv_result = ifft(fft(spk_train).*fft(gaussian_filter));
        %     avg_rates(i) = 1000 * mean(conv_result(end - size(t_rec,2) + 1:end));
        % end
        subplot(n_trials+1,1,i+1);
        gau_sdf = conv2(spk_times(i, :),gk,'same');
        %avg_frate = 1000*mean(gau_sdf);
        %disp(size(gau_sdf));

        avg_frate = sum(spk_times(i, :));

        plot(t, gau_sdf, 'g');
        % 
        title("Average Rate: " + string(avg_frate));
        xlabel('Time (ms)', 'FontSize', 7);
        ylabel('Fire Rate (Hz)', 'FontSize', 7);
        avg_rates(i) = avg_frate;

    end
    
end
