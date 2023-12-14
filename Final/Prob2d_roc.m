clear all; clc; close all;

rng("default");
up_rate = 26 + 6*randn(10000,1);
down_rate = 30 + 6*randn(10000,1);
max_up_rate = max(up_rate, [], "all");
max_down_rate = max(down_rate, [], "all");
bins_up_rate = 0:max_up_rate/20:max_up_rate;
bins_down_rate = 0:max_down_rate/20:max_down_rate;
hist_up_rate = hist(up_rate, bins_up_rate);
hist_down_rate = hist(down_rate, bins_down_rate);

comb_rates = reshape([up_rate down_rate], 1, []);
avg_rate = mean(comb_rates, "all");
std_rate = sqrt(var(comb_rates));

thresholds = max(comb_rates, [], "all"):-0.5:0;
beta = zeros(1, length(thresholds));
alpha = zeros(1, length(thresholds));
correct_probs = zeros(1, length(thresholds));
for i=1:length(thresholds)
    hit_rate_1_up = sum(up_rate > thresholds(i), "all") / 10000;
    hit_rate_1_down = (sum(down_rate < thresholds(i),"all")/10000);
    beta(1,i) = hit_rate_1_up;
    alpha(1,i) = 1 - hit_rate_1_down;
    correct_probs(1,i) = 0.5*(hit_rate_1_down + hit_rate_1_up);
end
figure();
plot(alpha, beta);
figure();
plot(correct_probs);

x = 0:0.1:max([max_down_rate, max_up_rate], [], "all");
cdf_up = 0.5*(1 + (1 - erfc((x - 25)/(sqrt(2)*6))));
cdf_down = 0.5*(1 + (1 - erfc((x - 30)/(sqrt(2)*6))));
prob_corr = 0.5*(cdf_down + (1 - cdf_up));

figure();
plot(x, 1 - cdf_down);
hold on;
plot(x, cdf_up);
hold on;
plot(x, prob_corr);
fx = abs(gradient(prob_corr));
indices = fx > (max(fx, [], "all") / 2);
disp(min(find(indices), [], "all"));
disp(max(find(indices), [], "all"));

% hold on;
% plot(x, cdf_down);

% max_rate = max(comb_rates, [], "all");
% figure(); bar(0:max_rate/20:max_rate, hist(comb_rates, 0:max_rate/20:max_rate))