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
comb_dist = comb_rates / sum(comb_rates);
avg_rate = mean(comb_rates, "all");
std_rate = sqrt(var(comb_rates));

training_it = 500;
lr = 0.01;
mu_up = avg_rate;
mu_down = avg_rate;
sigma_up = std_rate;
sigma_down = std_rate;
best_loss = 100;
recent_loss = 0;

g1 = gaussian(mu_up, sigma_up, length(comb_dist));
g2 = gaussian(mu_down+20, sigma_down, length(comb_dist));
figure();
plot(g1);
hold on;
plot(g2);
hold on;
plot(0.5*g1 + 0.5*g2);
for i=1:training_it 
    g1 = gaussian(mu_up, sigma_up, length(comb_dist));
    g2 = gaussian(mu_down, sigma_down, length(comb_dist));
    comb_gaussian = 0.5*g1 + 0.5*g2; %gaussian mixture modelss
    ce = cross_entropy(comb_dist, comb_gaussian);
    if ce < best_loss
        best_loss = ce;
    end
    if abs(ce - recent_loss) < 0.001
        break;
    else
        recent_loss = ce;
    end
    % dce_dmu_up = sum(comb_dist.*2.*((1:length(comb_dist)) - mu_up).*0.5.*sigma_up.^(-2), "all");
    dce_dmu_up = sum((comb_dist./comb_gaussian).*(-1/(2*sigma_up)).*(2*-1).*((1:length(comb_dist)) - mu_up).*g1, "all");
    dce_dmu_down = sum((comb_dist./comb_gaussian).*(-1/(2*sigma_down)).*(2*-1).*((1:length(comb_dist)) - mu_down).*g2, "all");
    dce_dsigma_up = sum((comb_dist./comb_gaussian).*((1:length(comb_dist)) - mu_up).^2*sigma_up.*g1, "all");
    dce_dsigma_down = sum((comb_dist./comb_gaussian).*((1:length(comb_dist)) - mu_down).^2*sigma_down.*g2, "all");

    disp(ce);
    mu_up = mu_up - lr*dce_dmu_up;
    sigma_up = sigma_up - lr*dce_dsigma_up;
    mu_down = mu_down - lr*dce_dmu_down;
    sigma_down = sigma_down - lr*dce_dsigma_down;

end

plot(comb_gaussian);


    