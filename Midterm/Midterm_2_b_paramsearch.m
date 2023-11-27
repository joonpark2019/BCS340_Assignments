
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 299; % [ms]

i_inj_factor = [0.1, 1, 5, 10, 100, 1000];

figure('Position', [50 50 1500 600])

% 
% for i = 1:length(i_inj_factor)
%     % i_inj = i_inj_factor(i)*[zeros(floor(100/dt), 1); ones(floor(time_interval/dt), 1)];
%     i_inj = i_inj_factor(i)*zeros(floor(time_interval/dt), 1);
%     v_m = hodkin_huxley(i_inj, time_interval);
%     TF = islocalmax(v_m);
%     %disp(sum(TF));
%     % disp(find(TF));
%     t = dt:dt:time_interval;
%     subplot(1, length(i_inj_factor), i);
%     plot(t, v_m, t(TF), v_m(TF),'r*');
%     title("Injected Current: " + string(i_inj_factor(i)) + " uA/cm^2");
%     xlabel('Time (ms)');
%     ylabel('Voltage (mV)s');
% 
% end


%% Initial logarithmic scale for visualization
i_test = [0.1, 1, 10, 100, 1000];
start_time = 50; %ms

for i = 1:length(i_test)
    i_inj = i_test(i)*[zeros(floor(start_time/dt), 1); ones(floor((time_interval - start_time)/dt), 1)];
    
    v_m = hodkin_huxley(i_inj, time_interval);
    v_m = v_m(start_time/dt:end);

    %damped_cond = check_damped(v_m);

    %disp(sum(TF));
    % disp(find(TF));
    TF_max = islocalmax(v_m);
    TF_min = islocalmin(v_m);
    t = start_time:dt:time_interval;
    subplot(1, length(i_inj_factor), i);
    plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    % title("Is NOT damped: " + string(damped_cond));
    title("Injected Current: " + string(i_test(i)) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)s');

end

%% Check appropriateness of condition for checking damping:
% i_levels = 100:1:300;
i_levels = 0.1:0.1:10;
is_damped = zeros(length(i_levels), 1);
for i=1:length(i_levels)
    is_damped(i) = check_damped(i_levels(i));
end

max_i_no_damp = i_levels(find(is_damped, 1, 'last'));
disp(max_i_no_damp);
vis_hh_sample(100);


%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function for displaying hodgkin huxley sample:

function vis_hh_sample(current)
    start_time = 50; end_time = 150; dt = 0.01;
    i_inj = current*[zeros(floor(start_time/dt), 1); ones(floor((end_time - start_time)/dt), 1)];
    
    v_m = hodkin_huxley(i_inj, end_time);
    v_m = v_m(start_time/dt:end);
    spk_t = digitize(v_m);
    TF_max = islocalmax(v_m);
    TF_min = islocalmin(v_m);
    t = start_time:dt:end_time;
    figure('Position', [50 50 900 1000]);
    subplot(1,2,1);
    plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    % title("Is NOT damped: " + string(damped_cond));
    title("Injected Current: " + string(current) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)s');
    subplot(1,2,2)
    stem(spk_t);
end


function [is_damped, rate] = hh_model_rate(current)
    start_time = 50; end_time = 10000;
    i_inj = current*[zeros(floor(start_time/dt), 1); ones(floor((time_interval - start_time)/dt), 1)];
    
    v_m = hodkin_huxley(i_inj, time_interval);
    v_m = v_m(start_time/dt:end);
end


function spk_train = digitize(voltages)
    maxima = voltages(islocalmax(voltages));
    minima = voltages(islocalmin(voltages));

    voltage_range = max(maxima) - min(minima);
    max_indx = find(maxima);
    min_indx = find(minima);
    spks = zeros(min(length(maxima), length(minima)), 1);
    for i=1:min(length(maxima), length(minima))
        if maxima(max_indx(i)) - minima(min_indx(i)) > 0.1*voltage_range
            spks(max_indx(i)) = 1;
        end
    end

    spk_train = spks;
    
end


%% run for a short interval of 100 ms (this is sufficient to determine damping or regular spiking
%% 
function is_damped = check_damped(current)
    start_time = 50; end_time = 150; dt = 0.01;
    i_inj = current*[zeros(floor(start_time/dt), 1); ones(floor((end_time - start_time)/dt), 1)];
    
    voltages = hodkin_huxley(i_inj, end_time);
    voltages = voltages(start_time/dt:end);

    maxima = voltages(islocalmax(voltages));
    minima = voltages(islocalmin(voltages));

    if length(maxima) <= 2
        is_damped = 1;
        return
    end
    voltage_range = max(maxima) - min(minima);
    max_avg = mean(maxima(3:end));
    min_avg = mean(minima(3:end));

    if (max_avg - min_avg) <= 0.1*voltage_range
        is_damped = 1;
    else
        is_damped = 0;
    end
end