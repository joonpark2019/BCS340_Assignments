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
time_interval = 1000; %[ms]
min_current = -5;
max_current = 10;
stochasticity = 1; %logic value for using noise


%fix random seed:
rng('default');

%% Testing Convolution:
tic;
% %no noise:
response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, max_current, stochasticity);
% % hold on;
% % response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current, stochasticity);
telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);



function response = response_curve_conv(n_trials, I_noise, time, min_I, max_I, stochastic)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        %use convolution for stochastic result:
        %avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time));
    end
    figure;
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Function');
    
end
