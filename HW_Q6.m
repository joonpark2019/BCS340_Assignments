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
I_input = 0;
I_noise = 0;
time_interval = 1000; %[ms]
min_current = -5;
max_current = 50;
stochasticity = 1; %logic value for using noise


%fix random seed:
rng('default');

%% Testing Convolution:
% tic;
% %no noise:
%spks = plot_conv(num_trials, I_input, I_noise, time_interval, stochasticity);
%figure;
%response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
%hold on;
% % response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
% telapsed = toc;
% disp("time elapsed (s):");
% disp(telapsed);


%% Plotting Response Curve using background noise from e
figure;
response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current);
hold on;
response_rates = response_curve_conv(num_trials, 1.880, time_interval, min_current, max_current);
legend('No Noise', 'Noise')



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

function response = response_curve_conv(n_trials, I_noise, time, min_I, max_I)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        %use convolution for stochastic result:
        %avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time));
    end
    
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Curve');
    
end


function I = interval_search(n_trials, I_min, I_max, rate_target, I_n, time)
    I_range = I_min:0.001:I_max;
    rate = 0;
    I = I_max;
    for I_input=I_range
        rate = mean(avg_fire_rate_conv(n_trials, I_input, I_n, time));
        if abs(rate - rate_target) < 0.05
            I = I_input;
            break
        end
    end
    
    disp("rate:");
    disp(rate);
end

