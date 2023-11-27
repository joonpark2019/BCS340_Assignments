clear all, clc, close all

% all time units are in ms: use 0.1ms intervals
avg_frate = 5 / 1000; % 5 Hz
dt = 0.1; % 0.1ms time interval
time_len = 1000; % 1 second: 1000 ms
num_trials = 1000;

avg_N = avg_frate * time_len;
S_analytic_1 = (1/2) * (log2(avg_N) + log2(2*pi) + log2(exp(1)));
n = 0:1:100; % made the number of possible number of spikes/train very large --> entropy should not become larger after this point
poisson_probs = (avg_N.^n.*exp(1).^(-1*avg_N))./factorial(n);
S_analytic_2 = entropy_rate(poisson_probs);

disp("Entropy (bits) found with Stirling Approximation: ");
disp(S_analytic_1);
disp("Entropy (bits) found with Poisson distribution with large range of possible spikes: ");
disp(S_analytic_2);

% prob_dist_mod = [0.0070    0.0310    0.0960    0.1340    0    0.1660    0.1510    0.0900    0.0680    0.0380    0.0230    0.0030 0.0080    0.0010        0.1830    0.0010];
n = 0:1:(16 - 1);
prob_dist_mod = (1:1:length(n))./length(n);
S_mod = entropy_rate(prob_dist_mod);
disp("Entropy (bits) of modified probability distribution: ");
disp(S_mod);

