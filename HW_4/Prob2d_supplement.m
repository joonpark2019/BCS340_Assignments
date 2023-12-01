clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate_1 = 20 / 1000; % 20 Hz
avg_frate_2 = 100 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 5;

sample_distribution = ones(num_trials, 1) ./ num_trials;
s_1 = entropy_rate(sample_distribution) / (avg_frate_1 * time_len);
s_2 = entropy_rate(sample_distribution) / (avg_frate_2 * time_len);


rates = (20/1000):(1/1000):(100/1000);

% entropies = -1*(rates.*log(rates) + (1.-rates).*log(1.-rates));
N = time_len / dt;
s = zeros(length(rates), 1);
% for i=1:length(rates)
%     comb_num_spks = factorial(floor(rates(i)*time_len));
%     comb_num_spks_2 = factorial(floor(N - rates(i)*time_len));
%     s(i) = factorial(N) / (comb_num_spks * comb_num_spks_2);
% end

entropies = -1 * (rates.*dt.*log(rates.*dt) + (1 - rates.*dt).*log(1 - rates.*dt));
figure();
subplot(1,2,1);
plot(rates, entropies);
subplot(1,2,2);
plot(rates, rates);
title("Rates vs. Entropy Factor");
xlabel("Average Firing Rates (spks / ms)");
ylabel("Rates, Entropy Factor");
