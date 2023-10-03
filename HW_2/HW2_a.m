clear all, clc, close all

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
global E_syn %[mV]
E_syn = 0; 
global tau_syn
tau_syn = 1;

num_trials = 10; %number of spike trains generated to estimate firing rate
I_noise_max = 20; % [mA]
time_interval = 10000; %[ms]
I_min = 0; % [mA]
I_max= 0; % [mA]

%fix random seed:
rng('default');

spk_t = [];

target_rate = 5;

[I_n_start, I_n_target] = noise_tuning(target_rate, num_trials, 0, I_noise_max, spk_t, time_interval);

function [I_n_start, I_n_target] = noise_tuning(target_rate, n_trials, I_inj, I_n_max, spk_input, time)
    I_n_start = 0; I_n_target_rough = 0; rate_at_targ = 0;
    
    start_rate_found = 0;
    for i_n=1:I_n_max
        avg_rate = mean(avg_fire_rate(n_trials, I_inj, i_n, spk_input, time)); 
        if avg_rate ~= 0 && ~start_rate_found
            I_n_start = i_n; start_rate_found = 1; disp("got start rate"); disp(I_n_start);
        end
        if (ceil(abs(avg_rate - target_rate)) < 2) && (avg_rate < target_rate)
            I_n_target_rough = i_n; disp("got rough target rate"); disp(I_n_target_rough); disp(avg_rate);
            break;
        end
    end

    for i_n_f=(I_n_target_rough):0.1:I_n_max
        avg_rate = mean(avg_fire_rate(n_trials, I_inj, i_n_f, spk_input, time)); 
        if abs(avg_rate - target_rate) < 0.2
            I_n_target = i_n_f; rate_at_targ = avg_rate;
            break; 
        end
    end


    disp("starting current [mA]: ");
    disp(I_n_start);
    disp("target current [mA]: ");
    disp(I_n_target);
    disp("rate at target current[mA]: ");
    disp(rate_at_targ);

end

