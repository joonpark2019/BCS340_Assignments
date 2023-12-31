
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
i_levels = 0.1:0.01:10;
is_damped = zeros(length(i_levels), 1);
for i=1:length(i_levels)
    is_damped(i) = check_damped(i_levels(i));
end

max_i_no_damp = i_levels(find(is_damped, 1, 'last'));
disp(max_i_no_damp);
vis_hh_sample(max_i_no_damp);

%% Use Bisection Method to Search for Threshold Current:
curr_threshold = bisectionMethod(1, 100, 0.1);
disp(curr_threshold);

%plot_response_function(0.1, 200);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function non_damped_current = bisection_search(current_1, current_2, max_iter, iter)
    curr = (current_1 + current_2) / 2;
    if ~check_damped(curr) || iter == max_iter
        non_damped_current = curr;
        return
    end
    bisection_search(current_1, curr, max_iter, iter+1);
    bisection_search(curr, current_2, max_iter, iter+1);
end


function c = bisectionMethod(a,b,error)%f=@(x)x^2-3; a=1; b=2; (ensure change of sign between a and b) error=1e-4
    c=(a+b)/2; 
    
    while abs(hh_model_rate(c))>error
        c=(a+b)/2;
        
    end

end


function rate = hh_model_rate(current)

    if check_damped(current) == 1
        rate = 0;
        return
    end
    start_time = 50; end_time = 10000 + 50; dt = 0.01;
    i_inj = current*[zeros(floor(start_time/dt), 1); ones(floor((end_time - start_time)/dt), 1)];
    
    v_m = hodkin_huxley(i_inj, end_time);
    v_m = v_m(start_time/dt:end);

    
    spk_t = digitize(v_m);
    rate = 1000 * sum(spk_t) / (end_time - start_time);
end



% input:
% - time: time in ms to run measurement
% - start_current: current to start measurement at

function plot_response_function(start_current, end_current)
    rates = response_function(1000, start_current, end_current, 0.1);
    currents = start_current:0.1:end_current;
    figure();
    plot(currents, rates);
    xlabel("Constant Current Input (mA)");
    ylabel("Firing Rate Output (Hz)");
    title("Response Function of Hodgkin-Huxley Model");
end

function rates = response_function(time, start_current, end_current, dcurr)
    start_time = 50; end_time = time+50; dt = 0.01;
    
    currents = start_current:dcurr:end_current;
    rates = zeros(length(currents), 1);
    for i=1:length(currents)
        if check_damped(currents(i)) == 1
            rates(i) = 0;
            continue
        end
        i_inj = currents(i)*[zeros(floor(start_time/dt), 1); ones(floor((end_time - start_time)/dt), 1)];
        
        v_m = hodkin_huxley(i_inj, end_time);
        v_m = v_m(start_time/dt:end);
        spk_t = digitize(v_m);
        rates(i) = 1000 * sum(spk_t) / time;
    end
end


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


% 
% function spk_train = digitize(voltages)
%     maxima = voltages(islocalmax(voltages));
%     minima = voltages(islocalmin(voltages));
% 
%     voltage_range = max(maxima) - min(minima);
%     max_indx = find(maxima);
%     min_indx = find(minima);
%     spks = zeros(min(length(maxima), length(minima)), 1);
%     for i=1:min(length(maxima), length(minima))
%         if maxima(max_indx(i)) - minima(min_indx(i)) > 0.1*voltage_range
%             spks(max_indx(i)) = 1;
%         end
%     end
% 
%     spk_train = spks;
% 
% end


function spk_train = digitize(voltages)
    maxima = islocalmax(voltages);
    max_indx = find(maxima);

    % disp(length(maxima));
    % disp(maxima(1:100));
    minima = islocalmin(voltages);
    min_indx = find(minima);

    voltage_range = max(voltages(maxima)) - min(voltages(minima));
    len = min(length(max_indx), length(min_indx));
    max_indx = max_indx(1:len);
    min_indx = min_indx(1:len);
    indices = voltages(max_indx) - voltages(min_indx) > 0.1*voltage_range;
    spks = zeros(length(voltages), 1);
    spks(max_indx(indices)) = 1;
    spk_train = spks;


    % disp(max_indx);
    % 
    % spks = zeros(length(voltages), 1);
    % for i=1:min(length(max_indx), length(min_indx))
    %     if maxima(max_indx(i)) - minima(min_indx(i)) > 0.1*voltage_range
    %         spks(max_indx(i)) = 1;
    %     end
    % end
    % 
    % spk_train = spks;
    
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
