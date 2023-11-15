clear all, clc, close all


 addpath(genpath("./utils"));

%fix random seed:
rng('default');

%% Poisson Spike Generator
num_trials = 100;   % # of trials
time = 100;         % ms
rates = 100:10:1000;          % # of spikes/s (average firing rate in Hz)
p = rates./1000;      % # of spikes/ms

T = 0.1:0.01:1;      % time in seconds
T = 1000 * T;       % convert to ms

stop_times = zeros(length(p), 1);


figure();
for j=1:length(p)
    for i = 1:length(T)
        
        spks_point = poisson_spk_train_point(num_trials, p(j), T(i));
        % subplot(1, length(T), i);
        % stem(spks_point);
        rates_per_trial = sum(spks_point, 2)./(T(i) / 1000);
        fano_factor = std(rates_per_trial)^2 / mean(rates_per_trial);
        if abs(fano_factor - 1)/mean([fano_factor, 1]) < 0.1
            stop_times(j) = T(i);
            break
        end
        % fano_factors(i) = fano_factor;
    end
end

linear_fit = polyfit(rates,stop_times,1);
yfit = linear_fit(1)*rates+linear_fit(2);

plot(rates, stop_times);
hold on;
plot(rates, yfit);
ylabel("Time needed to reach Fano Factor=1 (ms)");
xlabel("Average Input rate (Hz)");
title("Input Rate vs. Time Needed to attain Poisson Process");
