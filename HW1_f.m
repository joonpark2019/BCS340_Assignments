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

%Parameter initialization:
num_trials = 10; 
%I_input = -0.9860; %[mA]

%Noise current found in part e)
I_noise = 1.6200; %[mA]
time_interval = 1000; %[ms]
min_current = -5; %[mA]
max_current = 150; %[mA]

%fix random seed:
rng('default');

%% Plotting Response Function:
tic;

figure;
response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, max_current);

figure;
response_rates = response_curve_conv(num_trials, 0, time_interval, min_current, 50);
hold on;
response_rates = response_curve_conv(num_trials, I_noise, time_interval, min_current, 50);
legend("No Noise", "Noise Current = 1.62 mA")

telapsed = toc;
disp("time elapsed (s):");
disp(telapsed);



function response = response_curve_conv(n_trials, I_noise, time, min_I, max_I)
    I_inputs = min_I:0.1:max_I;
    for i_input = 1:length(I_inputs)
        response(i_input) = mean(avg_fire_rate_conv(n_trials, I_inputs(i_input), I_noise, time));
    end
    
    plot(I_inputs, response);
    xlabel('Input Current (mA)');
    ylabel('Average Firing Rate (Hz)');
    title('Response Function');
    
end
