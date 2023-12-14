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


figure();

bar(bins_up_rate, hist_up_rate);
hold on;
bar(bins_down_rate, hist_down_rate);
legend("Upward Stimuli", "Downward Stimuli");
xlabel("Firing Rates (Hz)");
ylabel("Frequency");
title("Histogram of Firing Rates for Upward and Downward Stimuli");