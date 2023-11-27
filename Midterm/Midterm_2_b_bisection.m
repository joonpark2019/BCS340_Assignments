
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 299; % [ms]

i_inj_factor = [0.1, 1, 5, 10, 100, 1000];

figure('Position', [50 50 1500 600])


%% Use Bisection Method to Search for Threshold Current:
curr_threshold = bisectSearch(0.1, 10);
disp(curr_threshold);

%plot_response_function(0.1, 200);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


function curr_non_damped = bisectSearch(curr_1, curr_2)
    curr_mid = (curr_1 + curr_2) / 2;
    disp(damped(curr_mid));
    while damped(curr_mid) < 10
        disp(damped(curr_mid));
        disp(damped(curr_1));
        disp(damped(curr_2));
        disp("$$$$$$$$$");
        if damped(curr_1) < 10 && damped(curr_mid) < 10
            curr_1 = curr_mid;
        else
            curr_2 = curr_mid;
        end
        curr_mid = (curr_1 + curr_2) / 2;
    end
    curr_non_damped = curr_mid;
end


function percentage = damped(current)
    start_time = 50; end_time = 150; dt = 0.01;
    i_inj = current*[zeros(floor(start_time/dt), 1); ones(floor((end_time - start_time)/dt), 1)];
    
    voltages = hodkin_huxley(i_inj, end_time);
    voltages = voltages(start_time/dt:end);

    maxima = voltages(islocalmax(voltages));
    minima = voltages(islocalmin(voltages));

    voltage_range = max(maxima) - min(minima);
    max_avg = mean(maxima(3:end));
    min_avg = mean(minima(3:end));

    percentage = 100 * (max_avg - min_avg) / voltage_range;
    % 
    % if length(maxima) <= 2
    %     is_damped = 1;
    %     return
    % end
    % voltage_range = max(maxima) - min(minima);
    % max_avg = mean(maxima(3:end));
    % min_avg = mean(minima(3:end));
    % 
    % if (max_avg - min_avg) <= 0.1*voltage_range
    %     is_damped = 1;
    % else
    %     is_damped = 0;
    % end
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
