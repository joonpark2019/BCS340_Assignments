
%% plot for convolution with gaussian for rate
function spks = plot_conv(n_trials, I, I_n, time)
    global E_spike
    global dt

    [t_rec, v_m] = spike_generator_stochastic(n_trials, I, time, I_n);
    
    %find all spikes in the input
    s = v_m == E_spike;
   
    %create a gaussian filter with a standard deviation of 1 ms:
    sigma = 1;
    

    t_offset = -10*sigma:dt:0;
    t = [t_offset t_rec];
    
    %add additional time offset at the beginning so that the gaussian filter centered at zero is
    %not cut off
    s_p = [zeros(n_trials, size(t_offset, 2)) s];

    gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));

    %setting up figure for plotting
    figure('Position', [50, 50, 1000, 900]);
    subplot(n_trials+1,1,1);
    plot(t, gaussian_filter);
    xlabel('Time (ms)', 'FontSize', 7);
    ylabel('Firing Rate (Hz)', 'FontSize', 7);
    title("Filter plot");


    t_len = length(t_rec);
    for i=1:n_trials

        spk_train = s_p(i, :);
        
        subplot(n_trials+1,1,i+1);

        % find times at which spikes occur
        s_times = find(s(i,:));
       
        %if there are no spikes, there is no need to compute the convolution:
        if isempty(s_times) || (length(s_times) == 1 && s_times(1) == 1)
            %disp("AAAAAA");
            conv_result = zeros(1, length(t_rec));
            avg_frate = 0;
        else
            
            conv_result = ifft(fft(spk_train).*fft(gaussian_filter)); %is it possible to make this computation shorter??

            
            conv_result = conv_result(end - t_len + 1:end);

            avg_frate = 1000 * mean(conv_result);
            %plot_result = [zeros(1, start_idx-1) conv_result(start_idx:end_idx) zeros(1, t_len - end_idx)];
          
        end

        plot(t_rec, conv_result);
  
        title("Average Rate: " + string(avg_frate));
        xlabel('Time (ms)', 'FontSize', 7);
        ylabel('Fire Rate (Hz)', 'FontSize', 7);
        avg_rates(i) = avg_frate;
    end

    spks = s;
end
