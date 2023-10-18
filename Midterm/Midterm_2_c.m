
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 299; % [ms]

i_inj_factor = [0.1, 1, 5, 10, 100, 1000];

figure('Position', [50 50 1500 600])

dt = 0.01;
t = dt:dt:2000;
threshold_current = 5; %meaningless init
A = (10 - threshold_current) / 2;
B = 2*pi/2000;
C = (10 + threshold_current) / 2;
i_sin = A*sin(B.*t) + C;

vis_hh_sample(0.01, 2000, 0.01, i_sin);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vis_hh_sample(start_time, end_time, dt, i_inj)
   
    
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
    %title("Injected Current: " + string(current) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)s');
    subplot(1,2,2)
    stem(spk_t);
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

