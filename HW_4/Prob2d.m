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
    
    spk_keys = unique(spk_outputs, 'rows');
    spk_freq = size(spk_keys, 1);
    for i=1:1:size(spk_keys, 1)
        matches = 0;
        for l=1:size(spk_outputs, 1)
            if (sum(intersect(spk_outputs(l, :),spk_keys(i, :), "rows"), "all") ~= 0)
                matches = matches + 1;
            end
        end

        spk_freq(i) = matches;
    end
    spk_freq_1 = spk_freq;
    probs = spk_freq./sum(spk_freq);
    num_spks = sum(spk_outputs, 2);
    avg_num_spks = mean(sum(spk_outputs, 2), "all");

    s_1(j) = entropy_rate(probs) / avg_num_spks;
    s_1_theor(j) = log2(exp(1) / (avg_frate_1 * dt(j)));
end
figure();
bar(spk_freq_1);
title("Histogram of Different Binary Spike Patterns (20 Hz)");
xlabel("Binary Spike Pattern Key");
ylabel("Frequency");
for j=1:length(dt)
    spk_outputs = poisson_spk_train_point(num_trials, avg_frate_2, time_len, dt(j));
    
    spk_keys = unique(spk_outputs, 'rows');
    spk_freq = size(spk_keys, 1);
    for i=1:1:size(spk_keys, 1)
        matches = 0;
        for l=1:size(spk_outputs, 1)
            if (sum(intersect(spk_outputs(l, :),spk_keys(i, :), "rows"), "all") ~= 0)
                matches = matches + 1;
            end
        end

        spk_freq(i) = matches;
    end
    spk_freq_2 = spk_freq;
    probs = spk_freq./sum(spk_freq);
    
    num_spks = sum(spk_outputs, 2);

    avg_num_spks = mean(sum(spk_outputs, 2), "all");

    s_2(j) = entropy_rate(probs) / avg_num_spks;
    s_2_theor(j) = log2(exp(1) / (avg_frate_2 * dt(j)));
end
figure();
bar(spk_freq_2);
title("Histogram of Different Binary Spike Patterns (100 Hz)");
xlabel("Binary Spike Pattern Key");
ylabel("Frequency");


figure();
plot(dt, s_1);
hold on;
plot(dt, s_2);
title("Time Resolution vs. Entropy per Spike");
xlabel("Time Resolution (ms)");
ylabel("Entropy per Spike (bits)");
legend('20 Hz Firing Rate','100 Hz Firing Rate');
