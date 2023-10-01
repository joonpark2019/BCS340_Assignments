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
I_noise = 0;
time_interval = 1000; %[ms]
min_current = 0;
max_current = 30;
stochasticity = 1; %logic value for using noise


%fix random seed:
rng('default');

%% Testing Convolution:
% tic;
% %no noise:
%spks = plot_conv(num_trials, I_input, I_noise, time_interval, stochasticity);
%figure;
response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
hold on;
% % response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
% telapsed = toc;
% disp("time elapsed (s):");
% disp(telapsed);


%% Response curve using JUST noise input
I_noise_min = -10;
I_noise_max = 10;
response_rates = noise_response_curve_conv(num_trials, I_noise_min, I_noise_max, time_interval, stochasticity);

%% First, find Noise value at which neuron first starts to fire
I_noise_test = I_noise_min:0.1:I_noise_max;
initial_current = 0;
for i_nse = I_noise_test
    rate = mean(avg_fire_rate_conv(num_trials, 0, i_nse, time_interval, stochasticity));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        initial_current = i_nse;
        disp("Initial current:");
        disp(initial_current);
        break
    end
end


%% Narrowing down the range for noise
I_noise = i_nse:0.01:2.0;
inse_five_hz = 0;
for i_n=1:length(I_noise)
    rate = mean(avg_fire_rate_conv(num_trials, 0, I_noise(i_n), time_interval, stochasticity));
    if abs(rate - 5) < 0.1
        disp("rate:");
        disp(rate);
        disp("Noise current:");
        disp(I_noise(i_n));
        inse_five_hz = I_noise(i_n);
        break
    end
end


s_train = plot_conv(num_trials, 0, inse_five_hz, time_interval, stochasticity);
spk_times = zeros(num_trials, size(s_train, 2));
for i=1:num_trials
    i_times = find(s_train(i, :));
    %disp(i_times);
    spk_times(i, 1:length(i_times)) = i_times;
end

%a num_trials x spk_train length sized array
sptimes = spk_times*dt;

raster_plot(sptimes, time_interval);



function response = noise_response_curve_conv(n_trials, I_noise_min, I_noise_max, time, stochastic)
    I_noise_inputs = I_noise_min:0.1:I_noise_max;
    for i_input = 1:length(I_noise_inputs )
        %use convolution for stochastic result:
        %avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_fire_rate_conv(n_trials, 0, I_noise_inputs(i_input), time, stochastic));
    end
    
    plot(I_noise_inputs, response);
    xlabel('Input Noise Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Noise Response Curve');
    
end

function response = response_curve_conv(n_trials, I_noise, time, min_I, max_I, stochastic)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        %use convolution for stochastic result:
        %avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic));
    end
    
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Curve');
    
end


function I = interval_search(n_trials, I_min, I_max, rate_target, I_n, time, stochastic)
    I_range = I_min:0.001:I_max;
    rate = 0;
    I = I_max;
    for I_input=I_range
        rate = mean(avg_fire_rate_conv(n_trials, I_input, I_n, time, stochastic));
        if abs(rate - rate_target) < 0.05
            I = I_input;
            break
        end
    end
    
    disp("rate:");
    disp(rate);
end



%% revised calculation for rate with gaussian:
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

   
    %create a gaussian filter:
    sigma = 5;
    

     %extend the length of the time so that the gaussian filter is not cut
    %off:
    t_offset = -10*sigma:dt:0;
    t = [t_offset t_rec];
    
    s_p = [zeros(n_trials, size(t_offset, 2)) s];

    gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));

    % measure_interval = 10 / dt; %in indices, not in ms
    % 
    % start_ind = abs(floor(randn*(size(t_rec) - measure_interval)));
    %plot all of the neurons
    
    for i=1:n_trials
        spk_train = s_p(i, :);
        s_times = find(s(i, :));
        if isempty(s_times) || (length(s_times) == 1 && s_times(1) == 1)
            avg_rates(i) = 0;
        else
            conv_result = ifft(fft(spk_train).*fft(gaussian_filter));
            avg_rates(i) = 1000 * mean(conv_result(end - size(t_rec,2) + 1:end));
        end
        
        
        %disp(size(conv_result(end - size(t_rec,2) + 1:end)));
        % disp(size(t_rec));

        
        
        
        
        % = avg_frate;
    end
    
end




%% plot for convolution with gaussian for rate
function spks = plot_conv(n_trials, I, I_n, time, stochastic)
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
    
    %add additional time offset at the beginning so that the gaussian filter centered at zero is
    %not cut off
    s_p = [zeros(num_neurons, size(t_offset, 2)) s];

    gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));

    %setting up figure for plotting
    figure('Position', [50, 50, 1000, 900]);
    subplot(n_trials+1,1,1);
    plot(t, gaussian_filter);
    xlabel('Time (ms)');
    ylabel('Firing Rate (Hz)');
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
            % min_interval = min(diff(s_times));
            % 
            % %disp(min_interval);
            % start_idx = min(s_times) + abs(floor(randn*min_interval));
            % %disp(start_idx);
            % end_idx =  start_idx + 5*min_interval;
            
            conv_result = conv_result(end - t_len + 1:end);
            % avg_frate = 1000 * mean(conv_result(start_idx:end_idx));
            avg_frate = 1000 * mean(conv_result);
            %plot_result = [zeros(1, start_idx-1) conv_result(start_idx:end_idx) zeros(1, t_len - end_idx)];
          
        end

        plot(t_rec, conv_result);
  
        title("Average Rate: " + string(avg_frate));
        avg_rates(i) = avg_frate;
    end

    spks = s;
end


%% Raster Plot function:
% taken from : https://www.youtube.com/watch?v=27Y2c596-U0
function raster_plot(sptimes, time_interval)
    
    figure('Units','normalized','Position',[0 0 .3 1])
    ax = subplot(4,1,1); hold on
    
    % For all trials...
    for iTrial = size(sptimes, 1):-1:1
                      
        spks            = sptimes(iTrial, :);         % Get all spikes of respective trial    
        spks            = spks(1:find(spks, 1, 'last'));
        %disp(size(spks));
        xspikes         = repmat(spks,3,1);         % Replicate array
        yspikes      	= nan(size(xspikes));       % NaN array
        
        if ~isempty(yspikes)
            yspikes(1,:) = iTrial-1;                % Y-offset for raster plot
            yspikes(2,:) = iTrial;
        end
        
        plot(xspikes, yspikes, 'Color', 'k')
    end
    
    ax.XLim             = [0 time_interval];
    ax.YLim             = [0 size(sptimes, 1)];
    ax.XTick            = [0 10]; %fix this!!!
    
    ax.XLabel.String  	= 'Time [ms]';
    ax.YLabel.String  	= 'Trials';

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
        + dt*(R/tau)* I_inj ...
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
        + dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;
        %- dt*(R/tau)* I_syn(:, i) ...

        %problem here with vectorization:
        spks = v_m(:, i) > E_thresh;
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
    end

end
