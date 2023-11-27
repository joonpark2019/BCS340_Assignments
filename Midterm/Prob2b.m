
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 299; % [ms]

i_inj_factor = [0.1, 1, 5, 10, 100, 1000];

figure('Position', [50 50 1500 600])

tic;
%% Initial logarithmic scale for visualization
i_test = [0.1, 1, 10, 100, 1000];
start_time = 50; %ms
% 
for i = 1:length(i_test)
    i_inj = i_test(i)*[zeros(floor(start_time/dt), 1); ones(floor((time_interval - start_time)/dt), 1)];

    v_m = hodkin_huxley(i_inj, time_interval);
    v_m = v_m(start_time/dt:end);


    TF_max = islocalmax(v_m); maxima = v_m(TF_max);
    TF_min = islocalmin(v_m); minima = v_m(TF_min);
    voltage_range = maxima(1) - minima(1);

    disp("%%%%%%%%%%%%%%%%%%%%%%");
    disp("Injected Current : " + string(i_test(i)) + " uA/cm^2");
    disp("Voltage range (mV):");
    disp(voltage_range);
    disp("Percentage of second local max. compared to Voltage Range (%)");
    disp(100 * (maxima(2) - minima(1)) / voltage_range);

    t = start_time:dt:time_interval;
    subplot(1, length(i_inj_factor), i);
    plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    % title("Is NOT damped: " + string(damped_cond));
    title("Injected Current: " + string(i_test(i)) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    legend("Voltage", "Local Maxima", "Local Minima");

end

%% Check appropriateness of condition for checking damping:
i_levels = 0.1:0.01:10;
is_damped = zeros(length(i_levels), 1);
for i=1:length(i_levels)
    is_damped(i) = check_damped(i_levels(i));
end

disp("%%%%%%%%%%%%%%%%%%%%%%");
max_i_no_damp = i_levels(find(is_damped, 1, 'last'));
disp("First Current with no damping: ");
disp(string(max_i_no_damp) + " uA/cm^2");
vis_hh_sample(max_i_no_damp);


plot_response_function(5, 200);
toc;

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% input:
% - start_current: initial current to inject
% - end_current: final current to inject

function plot_response_function(start_current, end_current)
    [rates, slope_mid, slope_fin, curr_fin] = response_function(10000, start_current, end_current, 0.1);
    currents = start_current:0.1:curr_fin;
    disp(size(rates));
    disp(size(currents));
    disp(curr_fin);

    %curr_mid = start_current + (end_current - start_current)/8;
    tang1 = (currents - 15)*slope_mid + rates(floor(10/0.1));
    tang2 = (currents - curr_fin)*slope_fin + rates(end);

    figure();
    plot(currents, rates);
    hold on
    plot(currents, tang1);
    hold on
    plot(currents, tang2);
    legend("Average Firing Rate", "Slope at " + string(15) + " uA/cm^2", "Slope at "+ string(curr_fin) + " uA/cm^2");
    xlabel("Constant Current Input (mA)");
    ylabel("Firing Rate Output (Hz)");
    title("Time vs. Average Firing Rate");
end

function [rates, slope_mid, slope_fin, curr_fin] = response_function(time, start_current, end_current, dcurr)
    start_time = 50; end_time = time+start_time; dt = 0.01;
    
    currents = start_current:dcurr:end_current;
    %rates = zeros(length(currents), 1);
    %%record slope at the middle of the interval [start_current,
    %%end_current]
    slope_mid = 0;
    disp("Length currents:");
    disp(length(currents));

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
        if floor(10/dcurr) <= i
            slope = abs(rates(i) - rates(i-10)) / (dcurr*10);
            if i == floor(10/dcurr)
                disp(slope_mid);

                slope_mid = slope;
            end
            if slope < 0.5*slope_mid
                
                disp(slope);
                disp(slope_mid);
                slope_fin = slope;
                curr_fin = currents(i);
                return
            end
        end
        

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
    title("Time vs. Voltage for Injected Current = " + string(current) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    legend("Voltage", "Local Maxima", "Local Minima");
    subplot(1,2,2)
    plot(t, spk_t);
    title("Spike Train for for Injected Current = " + string(current) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Spike');
    

end

function spk_train = digitize(voltages)
    maxima = islocalmax(voltages);
    max_indx = find(maxima);

    minima = islocalmin(voltages);
    min_indx = find(minima);

    voltage_range = max(voltages(maxima)) - min(voltages(minima));
    len = min(length(max_indx), length(min_indx));
    max_indx = max_indx(1:len);
    min_indx = min_indx(1:len);
    indices = voltages(max_indx) - voltages(min_indx) > 0.3*voltage_range;
    spks = zeros(length(voltages), 1);
    spks(max_indx(indices)) = 1;
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

    if (max_avg - min_avg) <= 0.3*voltage_range
        is_damped = 1;
    else
        is_damped = 0;
    end
end
