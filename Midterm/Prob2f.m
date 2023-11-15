
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');


%% Sinusoidal Input Signal
dt = 0.01;
t = dt:dt:2000;             % ms
threshold_current = 6.13;   % uA/cm^2
A = (10 - threshold_current) / 2;
B = 2*pi/200;
C = (10 + threshold_current) / 2;
i_sin = A*sin(B.*t) + C;

%% Rectangular pulse train Input Signal
i_pulse  = periodic_pulse_train(A, 200, 2000);
% frequency_analysis(i_pulse);


vis_hh_sample(dt, 2000, dt, i_sin);
vis_hh_sample(dt, 2000, dt, i_pulse);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function for generating rectangular periodic pulse train
function pulse_train = periodic_pulse_train(amplitude, period, time)
    dt = 0.01;
    period_len = period/dt; %[ms]
    train_len = floor(time/dt);
    % indices = 1:train_len;
    pulse = [zeros(1, floor(period_len/2)) ones(1, ceil(period_len/2))];
    pulse_train = [];
    for i=1:ceil(train_len/period_len)
        pulse_train = [pulse_train pulse];
    end
    pulse_train = amplitude*pulse_train;
end

%% function for generating the frequency spectrum
function frequency_analysis(input_signal)
    % Fs = 100;            % Sampling frequency                    
    % T = 1/Fs;             % Sampling period       
    L = length(input_signal);             % Length of signal
    Y = fft(input_signal);
    P2 = abs(Y/L);

    T = 2;
    Fs=1/(1e-5);
    % N = Fs*(T);
    f=0:1/T:Fs; f = f(1:end-1);

    % P1 = P2(1:2000);
    % P1(2:end-1) = 2*P1(2:end-1);
    % f = Fs*(0:(L/10))/L;
    % f = 1:L;
    figure('Position', [500 500 800 800]);
    plot(f(1:500),P2(1:500))
    title("Frequency Spectrum of Membrane Voltage")
    xlabel("Frequency (Hz)")
    ylabel("Amplitude")
end

%% Function for visualizing membrane voltage, spike train, and SDF
function vis_hh_sample(start_time, end_time, dt, i_inj)
    v_m = hodkin_huxley(i_inj, end_time);
    v_m = v_m(start_time/dt:end);

    % digitize the membrane voltage into a spike train
    spk_t = digitize(v_m);
    filtered_spk_t = gaussian_filter(spk_t);
    v_m_lp = lowpass(v_m, 50, (1/0.0001));
    %plot the frequency spectrum
    frequency_analysis(v_m_lp);

    TF_max = islocalmax(v_m);
    TF_min = islocalmin(v_m);
    t = start_time:dt:end_time;
    figure('Position', [50 50 900 1500]);
    subplot(1,3,1);
    plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
    hold on
    plot(t, i_inj);
    legend("Voltage", "Local Maxima", "Local Minima", "Injected Current (uA/cm^2)");

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
    ylabel('Instantaneous Firing Rate ()');
    title("Time vs. Instantaneous Firing Rate");

end

%% Smooth spikes with a Gaussian kernel:
function gau_sdf = gaussian_filter(spk_train)
    
   
    dt = 0.01;
    time_diffs = diff(find(spk_train))*dt;
    refrac_per = min(time_diffs);
    gau_sdf = conv2(spk_train,gausswin(refrac_per*5/0.01),'same');

end


%% Function for digitizing membrane voltages into spikes
%%  - reduced threshold to 1% of voltage range
function spk_train = digitize(voltages)

% find local minima and maxima
    maxima = islocalmax(voltages);
    max_indx = find(maxima);

    minima = islocalmin(voltages);
    min_indx = find(minima);

    voltage_range = max(voltages(maxima)) - min(voltages(minima));
    len = min(length(max_indx), length(min_indx));
    max_indx = max_indx(1:len);
    min_indx = min_indx(1:len);

    %find indices where local_max - local_min exceeds 1% of the voltage range
    indices = voltages(max_indx) - voltages(min_indx) > 0.01*voltage_range;
    spks = zeros(length(voltages), 1);
    spks(max_indx(indices)) = 1;
    spk_train = spks;

    
end

