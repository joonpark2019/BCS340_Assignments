clear all, clc, close all;
rng("default");

time_len = 2000; %ms
rate_pre = 50 / 1000;
dt = 0.1;

delay = -100:dt:100;
tau = 10;

input_spk = poisson_spk_train_point(1, rate_pre, time_len, dt);

mean_rate = sum(input_spk(1, 1:floor(100/dt)), "all") / 100;
rate_post = mean_rate * (0.1);
out_spk = poisson_spk_train_point(1, rate_post, 100, dt);

time_interval = floor(100/dt);
for i=1:1:(floor(time_len / 100) - 1)
    
    t = i*time_interval;
    mean_rate = sum(input_spk(1, (t - floor(100/dt)+1):t), "all") / 100;

    out_spk = [out_spk, poisson_spk_train_point(1, mean_rate*0.1, 100, dt)];
end

times = dt:dt:time_len;
figure();
subplot(1,2,1);
plot(times, input_spk);
title("Input Spike Train");
xlabel("time (ms)");
ylabel("Spike");
subplot(1,2,2);
plot(times, out_spk);
title("Output Spike Train Without STDP");
xlabel("time (ms)");
ylabel("Spike");