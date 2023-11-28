clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate_1 = 20 / 1000; % 20 Hz
avg_frate_2 = 100 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 0.5:0.5:5;
s_1 = zeros(size(dt));
s_1_theor = zeros(size(dt));
s_2 = zeros(size(dt));
s_2_theor = zeros(size(dt));

for j=1:length(dt)
    spk_outputs = poisson_spk_train_point(num_trials, avg_frate_1, time_len, dt(j));
    
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
    % figure();
    % bar(spk_freq);
    
    num_spks = sum(spk_outputs, 2);
    % disp(mean(num_spks, "all"));
    % disp(unique_keys(1));
    s_1(j) = entropy_rate(probs);
    
end

figure();
bar(spk_freq);

figure();
imagesc(spk_outputs);
for j=1:length(dt)
    spk_outputs = poisson_spk_train_point(num_trials, avg_frate_2, time_len, dt(j));
    
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
    % figure();
    % bar(spk_freq);
    
    num_spks = sum(spk_outputs, 2);
    % disp(mean(num_spks, "all"));
    % disp(unique_keys(1));
    s_2(j) = entropy_rate(probs);
    
end
figure();
bar(spk_freq);

figure();
imagesc(spk_outputs);

figure();
plot(dt, s_1);
hold on;
plot(dt, s_2);
legend('20 Hz Firing Rate','100 Hz Firing Rate');