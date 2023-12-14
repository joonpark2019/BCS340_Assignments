clear all; clc; close all;

rng("default");

mu_up = 25; sigma_up = 6;
mu_down = 30; sigma_down = 6;
up_rate = 25 + 6*randn(100,1);
down_rate = 30 + 6*randn(100,1);
max_up_rate = max(up_rate, [], "all");
max_down_rate = max(down_rate, [], "all");
% bins_up_rate = 0:max_up_rate/20:max_up_rate;
% bins_down_rate = 0:max_down_rate/20:max_down_rate;
% hist_up_rate = hist(up_rate, bins_up_rate);
% hist_down_rate = hist(down_rate, bins_down_rate);

comb_rates = reshape([up_rate down_rate], 1, []);
threshold_1 = mean(comb_rates, "all")+3;
% threshold_1 = mu_up;
x = 0:0.1:max(comb_rates, [], "all");


p_emp_up = sum(comb_rates > threshold_1, "all") / length(comb_rates);
p_emp_down = sum(comb_rates < threshold_1, "all") / length(comb_rates);


p_r_sup = (1/(sqrt(2*pi)*sigma_up)).* exp(-1*(((x)-mu_up).^2)/ (2*sigma_up^2));
p_r_sdown = (1/(sqrt(2*pi)*sigma_down)).* exp(-1*(((x)-mu_down).^2)/ (2*sigma_down^2));

p_r = (p_emp_up.*p_r_sup) + (p_emp_down.*p_r_sdown);
p_s_up = (p_emp_up*p_r_sup)./p_r;
p_s_down = (p_emp_down*p_r_sdown)./p_r;

r_opt_up = mean(0.1*find(abs(p_s_up - p_s_down) < 0.05), "all");
disp("r opt up");
disp(r_opt_up);


figure();
plot(x, p_s_up);
hold on;
plot(x, p_s_down);
legend("upward stimulus", "downward stimulus");
title("Probability of stimulus");
xlabel("rates");
ylabel("Probability");

