
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 299; % [ms]

i_inj_factor = [0.1, 1, 5, 10, 100, 1000];

% figure('Position', [50 50 1500 600])

dt = 0.01;
t = dt:dt:2000;
threshold_current = 6.17; %meaningless init
A = (10 - threshold_current) / 2;
B = 2*pi/2000;
C = (10 + threshold_current) / 2;
i_sin = A*sin(B.*t) + C;

vis_hh_sample(dt, 2000, dt, i_sin);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vis_hh_sample(start_time, end_time, dt, i_inj)
   
    
    % v_m = hodkin_huxley(i_inj, end_time);
    % v_m = v_m(start_time/dt:end);
    % spk_t = digitize(v_m);
    % % disp(find(spk_t));
    % % disp(length(spk_t));
    % filtered_spk_t = gaussian_filter(spk_t);
    % %disp(length(filtered_spk_t));
    % TF_max = islocalmax(v_m);
    % TF_min = islocalmin(v_m);
    % t = start_time:dt:end_time;
    % figure('Position', [50 50 900 1500]);
    % subplot(1,2,1);
    % plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    % hold on
    % plot(t, i_inj);
    % % title("Is NOT damped: " + string(damped_cond));
    % %title("Injected Current: " + string(current) + " uA/cm^2");
    % xlabel('Time (ms)');
    % ylabel('Voltage (mV)s');
    % subplot(1,2,2)
    % stem(spk_t);
    % figure();
    % plot(filtered_spk_t);

    v_m = hodkin_huxley(i_inj, end_time);
    v_m = v_m(start_time/dt:end);
    spk_t = digitize(v_m);
    % disp(find(spk_t));
    % disp(length(spk_t));
    filtered_spk_t = gaussian_filter(spk_t);
    %disp(length(filtered_spk_t));
    TF_max = islocalmax(v_m);
    TF_min = islocalmin(v_m);
    t = start_time:dt:end_time;
    figure('Position', [50 50 900 1500]);
    subplot(1,3,1);
    plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    hold on
    plot(t, i_inj);
    legend("Voltage", "Local Maxima", "Local Minima", "Injected Current (uA/cm^2)");
    % title("Is NOT damped: " + string(damped_cond));
    %title("Injected Current: " + string(current) + " uA/cm^2");
    xlabel('Time (ms)');
    ylabel('Voltage (mV)');
    title("Hodgkin Huxley Model: Time vs. Voltage");
    subplot(1,3,2)
    plot(t, spk_t);
    xlabel('Time (ms)');
    ylabel('Spike');
    title("Digitized Spikes");
    subplot(1,3,3);
    plot(t, filtered_spk_t);
    xlabel('Time (ms)');
    ylabel('Instantaneous Firing Rate (Hz)');
    title("Time vs. Instantaneous Firing Rate");
end

function gau_sdf = gaussian_filter(spk_train)
    %% Smooth spikes with a Gaussian kernel:
    
    dt = 0.01;
    time_diffs = diff(find(spk_train))*dt;
    refrac_per = min(time_diffs);

    gau_sdf = conv2(spk_train,gausswin(refrac_per*5/0.01),'same');

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
    indices = voltages(max_indx) - voltages(min_indx) > 0.1*voltage_range;
    spks = zeros(length(voltages), 1);
    spks(max_indx(indices)) = 1;
    spk_train = spks;

    
end

