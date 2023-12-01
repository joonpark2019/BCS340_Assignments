clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 5 / 1000; % 5 Hz
time_len = 1000; % 1 second: 1000 ms
num_trials = 1000;
dt = 0.1;
spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt);

num_spks = sum(spk_outputs, 2);
[n_bins, prob_hist] = prob_rate(num_spks);

%% analytic poisson distribution:
avg_N = avg_frate * time_len;
n = n_bins;
poisson_probs = (avg_N.^n.*exp(1).^(-1*avg_N))./factorial(n);

disp("Average Number of Spikes:");
disp(mean(num_spks));

%% plot both on on the same histogram:
figure();
bar(n_bins, prob_hist)
hold on
plot(n, poisson_probs)
title("Numerical Probability Distribution of Poisson Spike Train")
xlabel("Number of Spikes per Spike Train")
ylabel("Probability")
legend("Numerical Probability Distribution", "Analytic Poisson Probability Distribution")
