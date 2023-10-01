
%% revised calculation for rate with gaussian:
function avg_rates = avg_fire_rate_conv(n_trials, I, I_n, time)
    global E_spike
    global dt

    [t_rec, v_m] = spike_generator_stochastic(n_trials, I, time, I_n);
    
    %find all spikes in the input
    s = v_m == E_spike;

   
    %create a gaussian filter:
    sigma = 5;
    

     %extend the length of the time so that the gaussian filter is not cut
    %off:
    t_offset = -10*sigma:dt:0;
    t = [t_offset t_rec];
    
    s_p = [zeros(n_trials, size(t_offset, 2)) s];

    gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));
    
    for i=1:n_trials
        spk_train = s_p(i, :);
        s_times = find(s(i, :));
        if isempty(s_times) || (length(s_times) == 1 && s_times(1) == 1)
            avg_rates(i) = 0;
        else
            conv_result = ifft(fft(spk_train).*fft(gaussian_filter));
            avg_rates(i) = 1000 * mean(conv_result(end - size(t_rec,2) + 1:end));
        end

    end
    
end
