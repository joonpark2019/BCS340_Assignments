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

num_trials = 5;
I_input = 0;
I_noise = 2;
time_interval = 1000; %[ms]
min_current = -30;
max_current = 5;
stochasticity = 1; %logic value for using noise


%fix random seed:
rng('default');

%% Testing Convolution:
tic;
%no noise:
response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
% hold on;
% response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);

%% Raster plots:

%raster(num_trials, I_input, I_noise, time_interval, stochasticity);




%% Testing Raster plot
%raster(num_trials, I_input, I_noise, time_interval);

function response = response_curve_conv(n_trials, I_noise, time, min_I, max_I, stochastic)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        %use convolution for stochastic result:
        avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_rates);
    end
    
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Curve');
    
end

function response = response_curve_norm(n_trials, I_noise, time, min_I, max_I, stochastic)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        avg_rates = avg_fire_rate_norm(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        %indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        %response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_rates);
    end
    
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Curve');

end

% 
% function f_rate = avg_rate(n_trials, I, I_n, time)
%     global E_spike
%     global dt
% 
% 
%     [t_rec, v_m] = spike_generator(n_trials, I, time, I_n);
% 
%     %find all spikes in the input
%     s = v_m == E_spike;
%     nonzeroIndices = cell(size(s,1),1);
% 
%     for row=1:size(s,1)
%         nonzeroIndices{row} = find(spikeMatrix(row, :));
%     end
% 
%     if (size(spk_indices) <= 1)
%         disp("No spikes or only one spike!!");
%         return;
%     else
%         min_spk_interval(:) = spk_indices(:, 2) - spk_indices(:, 1);
%     end
% 
%     %number of trials
%     num_neurons = n_trials;
% 
%     start_ind = min(spk_indices) + abs(floor(min_spk_interval* randn)); %measure interval must be greater than
%     end_ind = start_ind + measure_interval;
% 
% end


%% plot for convolution with gaussian for rate
function plot_conv(n_trials, I, I_n, time)
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

    figure('Position', [500, 50, 1000, 1000]);

    subplot(num_neurons+1,1,1);
    plot(t, gaussian_filter);
    xlabel('Time (ms)');
    ylabel('Firing Rate (Hz)');
    title("Filter plot");

    % measure_interval = 10 / dt; %in indices, not in ms
    % 
    % start_ind = abs(floor(randn*(size(t_rec) - measure_interval)));
    %plot all of the neurons
    for i=1:num_neurons
        spk_train = s(i, :);
        conv_result = ifft(fft(spk_train).*fft(gaussian_filter));
        subplot(num_neurons+1,1,i+1);
        disp(size(conv_result(end - size(t_rec,2) + 1:end)));
        % disp(size(t_rec));
        plot(t_rec, conv_result(end - size(t_rec,2) + 1:end));
        
        avg_frate = 1000 * mean(conv_result(end - size(t_rec,2) + 1:end));
        title("Average Rate: " + string(avg_frate));
        avg_rates(i) = avg_frate;
    end
    
end




%% calculate normal rate without convolution:
function avg_rates = avg_fire_rate_norm(n_trials, I, I_n, time, stochastic)
    global E_spike
    global dt
    if stochastic == 1
        [t_rec, v_m] = spike_generator_stochastic(n_trials, I, time, I_n);
    else
        [t_rec, v_m] = spike_generator_standard(n_trials, I, time, I_n);
    end
    
    %find all spikes in the input
    s = v_m == E_spike;

    %number of trials
    num_neurons = size(v_m, 1);

    % start_ind = abs(floor(randn*(size(t_rec) - measure_interval)));
    %plot all of the neurons
    for i=1:num_neurons
        spk_train = s(i, :);

        %disp(size(conv_result(end - size(t_rec,2) + 1:end)));
        % disp(size(t_rec));
        
        avg_frate = 1000 * sum(spk_train) / time;
        
        avg_rates(i) = avg_frate;
    end
    
end



%% calculate convolution with gaussian for rate
function avg_rates = avg_fire_rate_conv(n_trials, I, I_n, time, stochastic)
    global E_spike
    global dt
    if stochastic == 1
        [t_rec, v_m] = spike_generator_stochastic(n_trials, I, time, I_n);
    else
        [t_rec, v_m] = spike_generator_standard(n_trials, I, time, I_n);
    end
    
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

%% function for raster plot
function raster(n_trials, I, I_n, time, stochastic)
    global E_spike
    if stochastic == 1
        [t_rec, v_m] = spike_generator_stochastic(n_trials, I, time, I_n);
    else
        [t_rec, v_m] = spike_generator_standard(n_trials, I, time, I_n);
    end
    
    
    s = v_m == E_spike;
    % Create a raster plot
    [rowIndices, timeIndices] = find(s);
    
    % Plot spikes as dots on a grid
    figure;
    scatter(timeIndices, rowIndices, 10, 'k', 'filled');  % Adjust 'k' for color and 'filled' for filled markers
    
    % Set plot properties
    xlabel('Time');
    ylabel('Neuron');
    title('Raster Plot');
    ylim([0.5, size(s, 1) + 0.5]);  % Set the y-axis limits to match the number of rows
    grid on;
    
    % Optionally, invert the y-axis to display the top row at the top
    set(gca, 'YDir', 'reverse');

end




%% Spike Generator Function

%this is a function for neuron with stochastic reset and stochastic
%conductance
%no synapses are considered in modelling
%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t, v_m] = spike_generator_standard(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    E_syn=-40;

    %sig_th_rand = 0.01;
    sig_el_rand = 5;
    sig_conductance = 0.01;
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
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) *(v_m(:, i-1) - E_rest) ...
        - dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;
        %- dt*(R/tau)* I_syn(:, i) ...

        %problem here with vectorization:
        spks = v_m(:, i) > E_thresh;
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_rest; %no random reset for standard leaky if
        
    end

end



%this is a function for neuron with stochastic reset and stochastic
%conductance
%no synapses are considered in modelling
%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t, v_m] = spike_generator_stochastic(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    E_syn=-40;

    %sig_th_rand = 0.01;
    sig_el_rand = 2;
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
