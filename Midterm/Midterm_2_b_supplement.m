
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');
% 
% time_interval = 299; % [ms]
% 
% i_inj_factor = [0.1, 1, 5, 10, 100, 1000];
% 
% % figure('Position', [50 50 1500 600])
% 
% dt = 0.01;
% t = dt:dt:2000;
% threshold_current = 6.13; %meaningless init
% A = (10 - threshold_current) / 2;

%% Visualize what activation fractions look like:

% hodkin_huxley_plot(i_sin_1, 2000);
% % 
% hodkin_huxley_plot(i_sin_2, 2000);
% 
% 
sample_pulse_train = periodic_pulse_train(500, 2000, 2000);
hodkin_huxley_plot(sample_pulse_train, 2000);

% vis_hh_sample(dt, 2000, dt, i_sin);

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%period in ms:
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
% 
% 
% 
% function vis_hh_sample_mod(start_time, end_time, dt, i_inj)
% 
% 
%     v_m = hodkin_huxley(i_inj, end_time);
%     v_m = v_m(start_time/dt:end);
%     spk_t = digitize_mod(v_m);
%     % disp(find(spk_t));
%     % disp(length(spk_t));
%     filtered_spk_t = gaussian_filter(spk_t);
%     %disp(length(filtered_spk_t));
%     TF_max = islocalmax(v_m);
%     TF_min = islocalmin(v_m);
%     t = start_time:dt:end_time;
%     figure('Position', [50 50 900 1500]);
%     subplot(1,2,1);
%     plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
%     hold on
%     plot(t, i_inj);
%     % title("Is NOT damped: " + string(damped_cond));
%     %title("Injected Current: " + string(current) + " uA/cm^2");
%     xlabel('Time (ms)');
%     ylabel('Voltage (mV)s');
%     subplot(1,2,2)
%     stem(spk_t);
%     figure();
%     plot(filtered_spk_t);
% end
% 
% function vis_hh_sample(start_time, end_time, dt, i_inj)
% 
% 
%     v_m = hodkin_huxley(i_inj, end_time);
%     v_m = v_m(start_time/dt:end);
%     spk_t = digitize(v_m);
%     % disp(find(spk_t));
%     % disp(length(spk_t));
%     filtered_spk_t = gaussian_filter(spk_t);
%     %disp(length(filtered_spk_t));
%     TF_max = islocalmax(v_m);
%     TF_min = islocalmin(v_m);
%     t = start_time:dt:end_time;
%     figure('Position', [50 50 900 1500]);
%     subplot(1,2,1);
%     plot(t, v_m, t(TF_max), v_m(TF_max),'r*', t(TF_min), v_m(TF_min),'b*');
%     hold on
%     plot(t, i_inj);
%     % title("Is NOT damped: " + string(damped_cond));
%     %title("Injected Current: " + string(current) + " uA/cm^2");
%     xlabel('Time (ms)');
%     ylabel('Voltage (mV)s');
%     subplot(1,2,2)
%     stem(spk_t);
%     figure();
%     plot(filtered_spk_t);
% end
% 
% function gau_sdf = gaussian_filter(spk_train)
%     %% Smooth spikes with a Gaussian kernel:
%     % sigma = 100;
%     % gaussian_range = -3*sigma:3*sigma; % setting up Gaussian window
%     % gaussian_kernel = normpdf(gaussian_range,0,sigma); % setting up Gaussian kernel
%     % gaussian_kernel = gaussian_kernel * (sqrt(2*pi)*sigma);
%     % 
%     % t = -10*sigma:0.01:10*sigma;
%     % gaussian_kernel = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));
%     % figure();
%     % plot(gausswin(50));
%     dt = 0.01;
%     time_diffs = diff(find(spk_train))*dt;
%     refrac_per = min(time_diffs);
% 
%     gau_sdf = conv2(spk_train,gausswin(refrac_per*5/0.01),'same');
%     %gau_sdf_p = conv2(spk_output_p,gaussian_kernel,'same');
%     % indices = 1:length(spk_train);
%     % indices = mod(indices, 10) == 0;
%     % 
%     % spk_train_downsample = spk_train(indices);
%     % dt = 0.1;
%     % t = dt:dt:(dt*length(spk_train_downsample));
%     % t_offset = -10*sigma:dt:0;
%     % t = [t_offset t];
%     % spks = [zeros(length(t_offset),1); spk_train_downsample];
%     % disp(size(spks));
%     % 
%     % gaussian_filter = 1/(sqrt(2*pi)*sigma) * exp(-t.^2 / (2*sigma^2));
%     % gau_sdf = ifft(fft(spks).*fft(gaussian_filter));
%     % 
%     % gau_sdf = gau_sdf(length(t_offset):end);
% 
% 
% end
% 
% function spk_train = digitize_mod(voltages)
%     maxima = islocalmax(voltages);
%     max_indx = find(maxima);
% 
% 
%     minima = islocalmin(voltages);
%     min_indx = find(minima);
% 
%     voltage_range = max(voltages(maxima)) - min(voltages(minima));
%     len = min(length(max_indx), length(min_indx));
%     max_indx = max_indx(1:len);
%     min_indx = min_indx(1:len);
%     indices = voltages(max_indx) - voltages(min_indx) > 0.01*voltage_range;
%     spks = zeros(length(voltages), 1);
%     spks(max_indx(indices)) = 1;
%     spk_train = spks;
% 
% end
% 
% function spk_train = digitize(voltages)
%     maxima = islocalmax(voltages);
%     max_indx = find(maxima);
% 
%     % disp(length(maxima));
%     % disp(maxima(1:100));
%     minima = islocalmin(voltages);
%     min_indx = find(minima);
% 
%     voltage_range = max(voltages(maxima)) - min(voltages(minima));
%     len = min(length(max_indx), length(min_indx));
%     max_indx = max_indx(1:len);
%     min_indx = min_indx(1:len);
%     indices = voltages(max_indx) - voltages(min_indx) > 0.1*voltage_range;
%     spks = zeros(length(voltages), 1);
%     spks(max_indx(indices)) = 1;
%     spk_train = spks;
% 
% end

