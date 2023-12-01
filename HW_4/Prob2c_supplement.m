clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 20 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 1000;
dt = 0.5:0.5:5;
s = zeros(size(dt));
s_theor = zeros(size(dt));

figure();
colormap(parula(length((dt))));

hold on;
for j=1:length(dt)
    spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt(j));
    
    spk_keys = unique(spk_outputs, 'rows');
    % disp(size(spk_keys));
    % disp(spk_keys);
    spk_freq = size(spk_keys, 1);
    for i=1:1:size(spk_keys, 1)
        matches = 0;
        for l=1:size(spk_outputs, 1)
            if (sum(intersect(spk_outputs(l, :),spk_keys(i, :), "rows"), "all") ~= 0)
                % disp("AAAAAA");
                matches = matches + 1;
            end
        end

        spk_freq(i) = matches;
    end
    
    probs = spk_freq./sum(spk_freq);
    % figure();
    % bar(spk_freq);
    bar(probs, 'EdgeAlpha', 0, 'FaceAlpha', 0.5);
    
    num_spks = sum(spk_outputs, 2);
    % disp(mean(num_spks, "all"));
    % disp(unique_keys(1));
    % s(j) = entropy_rate(probs) / (avg_frate * time_len);
    avg_num_spks = mean(sum(spk_outputs, 2), "all");
    % disp(avg_num_spks);
    s(j) = entropy_rate(probs) / avg_num_spks;
    s_theor(j) = log2(exp(1) / (avg_frate * dt(j)));
end
hold off;
legend('0.5 ms', '1.0 ms', '1.5 ms', '2.0 ms', '2.5 ms', '3.0 ms', '3.5 ms', '4.0 ms', '4.5 ms', '5.0 ms');
xlabel('Binary Spike Pattern Key');
ylabel('Frequency');
title('Empirical Spike Pattern Distribution');

figure();
plot(dt, s);
hold on;
plot(dt, s_theor);
title("Entropy/Spike vs. Time Resolution");
xlabel("Time Resolution (ms)");
ylabel("Entropy/Spike (bits)");
legend("Emprical Entropy at 20 Hz", "Theoretical Entropy at 20 Hz");