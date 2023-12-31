clear all; clc; close all;

rng("default");
up_rate = 40 + 5*randn(100,1);
down_rate = 20 + 5*randn(100,1);
max_up_rate = max(up_rate, [], "all");
max_down_rate = max(down_rate, [], "all");
bins_up_rate = 0:max_up_rate/20:max_up_rate;
bins_down_rate = 0:max_down_rate/20:max_down_rate;
hist_up_rate = hist(up_rate, bins_up_rate);
hist_down_rate = hist(down_rate, bins_down_rate);

comb_rates = reshape([up_rate down_rate], 1, []);
avg_rate = mean(comb_rates, "all");
std_rate = sqrt(var(comb_rates));

threshold_1 = avg_rate - std_rate;
threshold_2 = avg_rate;
threshold_3 = avg_rate + std_rate;

hit_rate_1_up = sum(up_rate > threshold_1, "all") / 100;
hit_rate_1_down = (sum(down_rate < threshold_1,"all")/100);
disp("Threshold 1:");
disp(threshold_1);
disp("Value of Beta at Threshold 1:");
disp(hit_rate_1_up);
disp("Value of Alpha at Threshold 1:");
disp(1 - hit_rate_1_down);
disp("Probability of Correct Answer");
disp((hit_rate_1_up+ hit_rate_1_down)/2);

hit_rate_2_up = sum(up_rate > threshold_2, "all") / 100;
hit_rate_2_down = (sum(down_rate < threshold_2, "all") / 100);
disp("Threshold 2:");
disp(threshold_2);
disp("Value of Beta at Threshold 2:");
disp(hit_rate_2_up);
disp("Value of Alpha at Threshold 2:");
disp(1 - hit_rate_2_down);
disp("Probability of Correct Answer");
disp((hit_rate_2_up+ hit_rate_2_down)/2);

hit_rate_3_up = sum(up_rate > threshold_3, "all") / 100;
hit_rate_3_down = (sum(down_rate < threshold_3, "all") / 100);
disp("Threshold 3:");
disp(threshold_3);
disp("Value of Beta at Threshold 3:");
disp(hit_rate_3_up);
disp("Value of Alpha at Threshold 3:");
disp(1 - hit_rate_3_down);
disp("Probability of Correct Answer");
disp((hit_rate_3_up+ hit_rate_3_down)/2);

figure();

bar(bins_up_rate, hist_up_rate);
hold on;
bar(bins_down_rate, hist_down_rate);
xline([threshold_1 threshold_2 threshold_3],'--r',{'-1 Standard Dev.','Average','+1 Standard Dev.'})
legend("Upward Stimuli", "Downward Stimuli");
xlabel("Firing Rates (Hz)");
ylabel("Frequency");
title("Histogram of Firing Rates for Upward and Downward Stimuli");

% max_rate = max(comb_rates, [], "all");
% figure(); bar(0:max_rate/20:max_rate, hist(comb_rates, 0:max_rate/20:max_rate))