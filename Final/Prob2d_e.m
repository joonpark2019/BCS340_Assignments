clear all; clc; close all;

rng("default");
up_rate = 26 + 6*randn(100,1);
down_rate = 30 + 6*randn(100,1);
max_up_rate = max(up_rate, [], "all");
max_down_rate = max(down_rate, [], "all");
bins_up_rate = 0:max_up_rate/20:max_up_rate;
bins_down_rate = 0:max_down_rate/20:max_down_rate;
hist_up_rate = hist(up_rate, bins_up_rate);
hist_down_rate = hist(down_rate, bins_down_rate);



comb_rates = reshape([up_rate down_rate], 1, []);
avg_rate = mean(comb_rates, "all");
std_rate = sqrt(var(comb_rates));

avg_rate = mean(comb_rates, "all");
std_rate = sqrt(var(comb_rates));

threshold_1 = avg_rate - std_rate;
threshold_2 = avg_rate;
threshold_3 = avg_rate + std_rate;
figure();

bar(bins_up_rate, hist_up_rate);
hold on;
bar(bins_down_rate, hist_down_rate);
xline([threshold_1 threshold_2 threshold_3],'--r',{'-1 Standard Dev.','Average','+1 Standard Dev.'})
legend("Upward Stimuli", "Downward Stimuli");
xlabel("Firing Rates (Hz)");
ylabel("Frequency");
title("Histogram of Firing Rates for Upward and Downward Stimuli");


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
title("ROC Curve");
xlabel(" \alpha");
ylabel(" \beta");
figure();
plot(correct_probs);
title("Probability of Correct Answer");
xlabel(" Threshold z (Hz)");
ylabel(" Probability");

x = 0:0.1:max([max_down_rate, max_up_rate], [], "all");
cdf_up = 0.5*(1 + (1 - erfc((x - 25)/(sqrt(2)*6))));
cdf_down = 0.5*(1 + (1 - erfc((x - 30)/(sqrt(2)*6))));
prob_corr = 0.5*(cdf_down + (1 - cdf_up));

fx = abs(gradient(prob_corr));
indices = fx > (max(fx, [], "all") / 10);
disp(min(find(indices), [], "all"));
disp(max(find(indices), [], "all"));

thresh_1 = min(find(indices), [], "all");
thresh_2 = max(find(indices), [], "all");
tang_1 = -1*fx(thresh_1)*((1:1:length(prob_corr)) - thresh_1) + prob_corr(thresh_1);
tang_2 = fx(thresh_2)*((1:1:length(prob_corr)) - thresh_2) + prob_corr(thresh_2);

figure();
plot(x, cdf_down);
hold on;
plot(x, 1 - cdf_up);
hold on;
plot(x, prob_corr);
xlabel("Threshold Value (Hz)");
ylabel("Probability");
title("Alpha, Beta Values, Correct Probability Distribution");
legend("Alpha", "Beta", "Probability of Correct Answer");

figure();
plot(x, prob_corr);
hold on;
plot(x, tang_1);
hold on;
plot(x, tang_2);
hold on; plot(x(thresh_1), prob_corr(thresh_1), "*r"); hold on; plot(x(thresh_2), prob_corr(thresh_2), "*r");
xlabel("Threshold Value (Hz)");
ylabel("Probability");
title("Correct Probability Distribution");
legend("Correct Probability Distribution", "Tangent Line at Quarter Maximum Slope", "Tangent Line at Quarter Maximum Slope");



% hold on;
% plot(x, cdf_down);

% max_rate = max(comb_rates, [], "all");
% figure(); bar(0:max_rate/20:max_rate, hist(comb_rates, 0:max_rate/20:max_rate))