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
min_current = -5;
max_current = 30;


%fix random seed:
rng('default');

I_noise_min = 0;
I_noise_max= 5;

%% First, find Noise value at which neuron first starts to fire
I_noise_test = I_noise_min:0.1:I_noise_max;
initial_current = 0;
for i_nse = I_noise_test
    rate = mean(avg_fire_rate_conv(10, 0, i_nse, time_interval));
    if rate > 0
        %noise current at which neuron starts firing even with zero input
        initial_current = i_nse;
        disp("Initial current:");
        disp(initial_current);
        break
    end
end


%% Narrowing down the range for noise which causes 5Hz firing rate
I_noise = i_nse:0.01:2.0;
inse_five_hz = 0;
for i_n=1:length(I_noise)
    rate = mean(avg_fire_rate_conv(10, 0, I_noise(i_n), time_interval));
    if abs(rate - 5) < 0.5
        disp("rate:");
        disp(rate);
        disp("Noise current:");
        disp(I_noise(i_n));
        inse_five_hz = I_noise(i_n);
        break
    end
end


%% Display spike train using a raster plot at which the average firing rate is 5 Hz
s_train = plot_conv(num_trials, 0, inse_five_hz, time_interval);
spk_times = zeros(num_trials, size(s_train, 2));
for i=1:num_trials
    i_times = find(s_train(i, :));
    %disp(i_times);
    spk_times(i, 1:length(i_times)) = i_times;
end

%a num_trials x spk_train length sized array
sptimes = spk_times*dt;

raster_plot(sptimes, time_interval);

%% Plotting Response Curve using background noise from e
figure;
response_rates = response_curve_conv(10, inse_five_hz, time_interval, min_current, max_current);




function response = noise_response_curve_conv(n_trials, I_noise_min, I_noise_max, time)
    I_noise_inputs = I_noise_min:0.1:I_noise_max;
    for i_input = 1:length(I_noise_inputs )
        %use convolution for stochastic result:
        %avg_rates = avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time, stochastic);
        % indices = abs(avg_rates - mean(avg_rates)) < sqrt(var(avg_rates));
        % response(i_input) = mean(avg_rates(indices == 1));
        response(i_input) = mean(avg_fire_rate_conv(n_trials, 0, I_noise_inputs(i_input), time));
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
