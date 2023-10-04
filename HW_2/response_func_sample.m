clear all, clc, close all

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

%% Parameter initialization:
time_interval = 10000; %1000 ms = 1s
fr_mean = 10/1000; %make 500 Hz input spike train

%% Generate regular and poisson spike trains:
spks_r = regular_spk_train(fr_mean, time_interval);
spks_r_t = floor(spks_r / dt);
spikes_r = zeros(1, time_interval/dt);
spikes_r(spks_r_t) = 1;
spikes_r = spikes_r(1:time_interval/dt);


disp(length(spks_r));
spks_p = poisson_spk_train(fr_mean, time_interval);

spks_p_t = floor(transpose(spks_p) / dt);
spikes_p = zeros(1, time_interval/dt);
spikes_p(spks_p_t) = 1;
spikes_p = spikes_p(1:time_interval/dt);

figure();
t = dt:dt:time_interval;
% plot(t, spks_r);
% figure();
plot(t, spikes_p);

spk_output_r = synaptic_neuron(1, 0, 5, spks_r, time_interval, 1);
spk_output_p = synaptic_neuron(1, 0, 5, spks_p, time_interval, 1);

corr_r = response_function(spikes_r, spk_output_r);
disp(corr_r(1,2));
corr_p = response_function(spikes_p, spk_output_p);
disp(corr_p(1,2));

% %% Smooth spikes with a Gaussian kernel:
% sigma = 5;
% gaussian_range = -3*sigma:3*sigma; % setting up Gaussian window
% gaussian_kernel = normpdf(gaussian_range,0,sigma); % setting up Gaussian kernel
% gaussian_kernel = gaussian_kernel * (sqrt(2*pi)*sigma);
% 
% gau_sdf_r = conv2(spk_output_r,gaussian_kernel,'same');
% gau_sdf_p = conv2(spk_output_p,gaussian_kernel,'same');
% figure();
% plot(gau_sdf_r);
% figure();
% plot(gau_sdf_p);
% 
% %% Create autocorrelation functions:
% Rxx_r = xcorr(gau_sdf_r);
% Rxx_p = xcorr(gau_sdf_p);
% 
% xdft_r = abs(fftshift(fft(Rxx_r,length(Rxx_r)))); 
% xdft_p = abs(fftshift(fft(Rxx_p,length(Rxx_p)))); 
% 
% Fs = 1000;
% 
% freq = -Fs/2:Fs/length(Rxx_r):Fs/2-(Fs/length(Rxx_r));
% figure(); 
% plot(freq,xdft_r);
% figure(); 
% plot(freq,xdft_p);