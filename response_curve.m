clear; close all; 

%% Setting some constants and initial values

%setting as global variables to be used in the spike generator
global E_rest
E_rest = -65; % resting potential [mV]
global tau
tau = 20; % time constant [ms]
global dt
dt=0.1; % integration time step [ms]
global R
R = 10; %resistance(Ohms)
global E_thresh
E_thresh = -55; %threshold voltage for spikes [mV]
global E_spike %[mV]
E_spike = 10;

num_trials = 10;
I_input = -1.1;
I_noise = 1;
time_interval = 1000; %[ms]

response_curve_gen(num_trials, 0, time_interval);

function response_curve_gen(n_trials, I_n, time)
    I_c = -40:0.1:5;
    
    for i = 1:size(I_c, 2)
        average_firing_rate = avg_rate_conv(n_trials, I_c(i), I_n, time);
        indices = abs(average_firing_rate - mean(average_firing_rate)) < sqrt(var(average_firing_rate));
        avg = mean(average_firing_rate(indices));
        avg_rates(i) = avg;
    end
    plot(I_c, avg_rates);
    xlabel('Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Plot');
end


%% plot for convolution with gaussian for rate
function avg_rates = avg_rate_conv(n_trials, I, I_n, time)
    global E_spike
    global dt
    [t_rec, v_m] = spike_generator(n_trials, I, time, I_n);
    
    %find all spikes in the input
    s = v_m == E_spike;

    %number of trials
    num_neurons = size(v_m, 1);

   
    %create a gaussian filter:
    sigma = 5;
    

     %extend the length of the time so that the gaussian filter is not cut
    %off:
    t_offset = -10*sigma:dt:0;
    t = [t_offset t_rec];
    
    s = [zeros(num_neurons, size(t_offset, 2)) s];

    gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));

    % disp(size(s));
    % disp(size(t));


    % measure_interval = 10 / dt; %in indices, not in ms
    % 
    % start_ind = abs(floor(randn*(size(t_rec) - measure_interval)));
    %plot all of the neurons
    for i=1:num_neurons
        spk_train = s(i, :);
        conv_result = ifft(fft(spk_train).*fft(gaussian_filter));
        
        %disp(size(conv_result(end - size(t_rec,2) + 1:end)));
        % disp(size(t_rec));
        
        avg_frate = 1000 * mean(conv_result(end - size(t_rec,2) + 1:end));
        
        avg_rates(i) = avg_frate;
    end
    
end

%% plot for convolution with gaussian for rate
function avg_rates = avg_rate_simple(n_trials, I, I_n, time)
    global E_spike
    global dt
    [t_rec, v_m] = spike_generator(n_trials, I, time, I_n);
    
    %find all spikes in the input
    s = v_m == E_spike;

    %number of trials
    num_neurons = size(v_m, 1);

   
    

    % measure_interval = 10 / dt; %in indices, not in ms
    % 
    % start_ind = abs(floor(randn*(size(t_rec) - measure_interval)));
    %plot all of the neurons
    for i=1:num_neurons
        spk_train = s(i, :);
        
        
        avg_rates(i) = 1000 * sum(spk_train) / 1000;
    end
    
end

%% Spike Generator Function

%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t, v_m] = spike_generator(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    E_syn=-40;

    %sig_th_rand = 0.01;
    sig_el_rand = 0.5;
    sig_conductance = 0.1;
    %sig_I_rand = 10;

    g_syn(:, 1)= zeros(N, 1); I_syn(:, 1)= zeros(N, 1); 
    v_m(:, 1)=zeros(N, 1); t(1)=0;

    E_L = E_rest + randn(N,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;
        
        %Don't consider any synapses from another cell (consider cell in
        %isolation)
        %Make the 

        %g_syn(:, i)= g_syn(:, i-1) - dt/tau * g_syn(:, i-1);
        %I_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) *(1 + sig_conductance * randn(N, 1)).* (v_m(:, i-1) - E_rest) ...
        - dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;
        %- dt*(R/tau)* I_syn(:, i) ...

        %problem here with vectorization:
        spks = v_m(:, i) > E_thresh;
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
    end

end