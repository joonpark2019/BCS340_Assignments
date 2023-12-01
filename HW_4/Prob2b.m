clear all, clc, close all

rng("default");
% all time units are in ms: use 0.1ms intervals
avg_frate = 20 / 1000; % 20 Hz
time_len = 100; % ms
num_trials = 100;
dt = 5;

spk_outputs = poisson_spk_train_point(num_trials, avg_frate, time_len, dt);
    
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
s = entropy_rate(probs) / avg_num_spks;
disp("Empirical Entropy per Spike (bits)");
disp(s);
s_theor = log2(exp(1) / (avg_frate * dt));
disp("Theoretical Entropy per Spike (bits)");
disp(s_theor);

%%%%%%%%%%% Theoretical Entropy calculation:%%%%%%%%%%%%%%%%%

s_theor = 2*log2(exp(1) / (20*0.005));
s_theor_2 = -(0.1/(log(2)*0.005)) *(20*0.005*log(20*0.005) + (1 - (20*0.005))*log(1 - (20*0.005)));


% num_spks = sum(spk_outputs, 2);
% [n_bins, prob_hist] = prob_rate(num_spks);

%% plot both on on the same histogram:
figure();
bar(probs);
title("Probability of Binary Spike Pattern")
xlabel("Binary Spike Pattern Key")
ylabel("Probability")

s_analytic_comb = log2(190);
s_analytic = 20 * 0.1 * log2(exp(1) / (20 * 0.005));

