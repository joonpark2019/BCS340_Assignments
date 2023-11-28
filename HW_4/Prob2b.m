clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 20 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 5;
spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt);

spk_keys = zeros(length(spk_outputs), 1);
for i=1:1:size(spk_outputs, 1)
    ind = find(spk_outputs(i, :));
    spk_keys(i) = turn_into_num(ind);
end
unique_keys = unique(spk_keys);
spk_freq = zeros(length(unique_keys), 1);
for k=1:length(unique_keys)
    spk_freq(k) = sum(unique_keys(k) == spk_keys, "all");
end

% histogram = hist(spk_freq, 1:1:length(spk_freq));
probs = spk_freq./sum(spk_freq); %normalize frequencies to probabilities
s = entropy_rate(probs);
disp("Entropy (bits)");
disp(s);

% num_spks = sum(spk_outputs, 2);
% [n_bins, prob_hist] = prob_rate(num_spks);

%% plot both on on the same histogram:
figure();
bar(spk_freq);
title("Histogram of Spikes")
xlabel("Spike Key")
ylabel("Frequency")

s_analytic_comb = log2(190);
s_analytic = 20 * 0.1 * log2(exp(1) / (20 * 0.005));

