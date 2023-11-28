clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 20 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 0.5:0.5:5;
s = zeros(size(dt));
s_theor = zeros(size(dt));

for j=1:length(dt)
    spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt(j));
    
    spk_keys = zeros(length(spk_outputs), 1);
    for i=1:1:size(spk_outputs, 1)
        ind = find(spk_outputs(i, :));
        spk_keys(i) = sum(ind);
    end
    unique_keys = unique(spk_keys);
    spk_freq = zeros(length(unique_keys), 1);
    for k=1:length(unique_keys)
        spk_freq(k) = sum(unique_keys(k) == spk_keys, "all");
    end
    
    probs = spk_freq./sum(spk_freq);
    figure();
    bar(spk_freq);
    
    num_spks = sum(spk_outputs, 2);
    % disp(mean(num_spks, "all"));
    disp(unique_keys(1));
    s(j) = entropy_rate(probs);
    s_theor(j) = avg_frate * time_len * log2(exp(1) / (avg_frate * dt(j)));
end

figure();
plot(dt, s);
hold on;
plot(dt, s_theor);
