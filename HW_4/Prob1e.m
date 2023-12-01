clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate_estimate = 5 / 1000; % 5 Hz
time_len = 1000; % 1 second: 1000 ms
num_trials = 10;
dt = 0.1;

% start with an initial estimate of the average firing rate:
avg_N = avg_frate_estimate* time_len;
n = 1:1:20; %fix n
poisson_prior = (avg_N.^n.*exp(1).^(-1*avg_N))./factorial(n);
bel = poisson_prior;

% perform grid search over 
avg_N_estimates = avg_N - 4:0.1:avg_N + 5;
min_kl_div = 200000;
min_kl_div_ind = 1;

% Collect 10 Poisson spike train samples:
spk_outputs = poisson_spk_train_point(10, avg_N, time_len, dt);
num_spks = sum(spk_outputs);
prob_dist = hist(num_spks, n);
prob_dist = prob_dist / (sum(prob_dist, "all") + 0.001);
entropy = entropy_rate(prob_dist);
disp("Empirical Entropy (bits)");
disp(entropy);

%find the 
for i=1:length(avg_N_estimates)
    poiss_dist = poisson_analytic(avg_N_estimates(i), n);

    kl_div_loss = cross_entropy(poiss_dist, prob_dist);
    if kl_div_loss < min_kl_div
        min_kl_div = kl_div_loss;
        min_kl_div_ind = i;
    end
end

disp(avg_N);
disp("Optimal average rate:");
disp(avg_N_estimates(min_kl_div_ind));

poiss_dist = poisson_analytic(avg_N_estimates(min_kl_div_ind), n);
poiss_dist_theor = poisson_analytic(avg_N, n);

figure();
bar(prob_dist);
hold on;
plot(n, poiss_dist);
hold on;
plot(n, poiss_dist_theor);
title("Empirical Distribution and Fitted Distribution");
ylabel("Probability");
xlabel("Number of Spikes per Spike Train");
legend("Empirical Probability Distribution", "Poisson Distribution Fit with Cross Entropy", "Theoretical Poisson Distribution (5 Hz)");



% must add proof that the given method works better