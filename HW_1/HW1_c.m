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
I_input = -0.9860;
I_noise = 0;
time_interval = 10000; %[ms]
min_current = -1.0;
max_current = 0;
stochasticity = 1; %logic value for using noise


%fix random seed:
rng('default');

%% Testing Convolution:
% tic;
% %no noise:
% response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
% % hold on;
% % response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
% telapsed = toc;
% disp("time elapsed (s):");
% disp(telapsed);

%% Trying to find 20Hz:


tic;
I_min = 0;
I_max= 5;

%% First, find Noise value at which neuron first starts to fire
I_test = I_min:0.01:I_max;
initial_current = 0;
for i_input = I_test
    rate = mean(avg_fire_rate_conv(10, i_input, 0, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        initial_current = i_input;
        disp("Initial current:");
        disp(initial_current);
        disp("Rate at initial current:");
        disp(rate);
        break
    end
end

% 
% 
% 
% %I = find_current(num_trials, I_input, 1, I_noise, time_interval, stochasticity);
% disp(mean(avg_fire_rate_conv(num_trials, I_input, I_noise, time_interval, stochasticity)));
% I_result = interval_search(num_trials, min_current, max_current, 1, I_noise, time_interval, stochasticity);
% disp("Current: ");
% disp(I_result);
% 
% rates = [0.99 0.8 0.7 0.6 0.5];
% for rr=rates
%     I_result = interval_search(num_trials, I_result, max_current, rr, I_noise, time_interval, stochasticity);
%     disp("Current: ");
%     disp(I_result);
% 
% end

%% Trying to plot raster plot for lowest achievable firing rate:

% s_train = plot_conv(num_trials, i_twenty_hz, 0, time_interval);
% spk_times = zeros(num_trials, size(s_train, 2));
% for i=1:num_trials
%     i_times = find(s_train(i, :));
%     %disp(i_times);
%     spk_times(i, 1:length(i_times)) = i_times;
% end
% 
% %a num_trials x spk_train length sized array
% sptimes = spk_times*dt;
% 
% raster_plot(sptimes, time_interval);



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


% 


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


function I = find_current(n_trials, I_start, rate_target, I_n, time, stochastic)
    
    I_update = I_start;
    rate = mean(avg_fire_rate_conv(n_trials, I_update, I_n, time, stochastic)); %some value not equal to 
    n = 0;
    max_it = 100;
    while abs(rate - rate_target) > 0.001
        if n > max_it
            break
        end
        n = n + 1;
        I_update = I_update * (1 + 0.1^n);
        rate = mean(avg_fire_rate_conv(n_trials, I_update, I_n, time, stochastic));
    end
    disp("rate:");
    disp(rate);
    I = I_update;
end
