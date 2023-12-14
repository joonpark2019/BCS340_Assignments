clear all, clc, close all;
rng("default");


time_len = 5000; %ms
rate_pre = 50 / 1000;
dt = 0.1;

delay = -100:dt:100;
tau = 10;
kernel = 100 * (exp(-1*delay / tau).*(delay > 0) - exp(delay / tau).*(delay < 0));

input_spk = poisson_spk_train_point(1, rate_pre, time_len, dt);

time = 120; %ms
mean_rate = sum(input_spk(1, 1:floor(100/dt)), "all") / 100;
rate_post = mean_rate * (0.1);
out_spk_no_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
out_spk_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
while sum(out_spk_stdp) == 0
    out_spk_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
end


epsc = zeros(1, floor(time_len / 100));
rate_post_r = 0;
for t=floor(100/dt):floor(100/dt):floor(time_len/dt)
    mean_rate = sum(input_spk(1, (t - floor(100/dt)+1):t), "all") / 100;
    spk_times_output = find(out_spk_stdp(1, (t - floor(100/dt)+1):t));

    % in case there are no spikes within the 100 ms interval:
    if isempty(spk_times_output)
        out_spk_stdp = [out_spk_stdp, poisson_spk_train_point(1, rate_post_r, 100, dt)];
        continue;
    end


    mean_time = mean(spk_times_output, "all");
    avg_input_timing = mean(find(input_spk(1, (t - floor(100/dt)+1):t)), "all");
    delay = dt*(mean_time - avg_input_timing);
    kernel = (exp(-1*delay / tau).*(delay > 0) - exp(delay / tau).*(delay < 0));
    epsc(1, floor(t/(100/dt))) = kernel;
    rate_post = mean_rate *(0.1 + kernel);
    rate_post_r = rate_post;
    disp(mean_rate);
    disp(mean_time);
    disp(avg_input_timing);
    disp(rate_post);
    out_spk_stdp = [out_spk_stdp, poisson_spk_train_point(1, rate_post, 100, dt)];
    out_spk_no_stdp = [out_spk_no_stdp, poisson_spk_train_point(1, mean_rate*0.1, 100, dt)];
end

loc_max_epsc = epsc > 0.4;
epsc_pks = zeros(1, length(out_spk_stdp));
epsc_pks(1, floor(100/dt) * find(loc_max_epsc)) = 1;

times = dt:dt:time_len;
figure();
subplot(1,3,1);
plot(times, input_spk);
title("Input Spike Train");
xlabel("time (ms)");
ylabel("Spike");
subplot(1,3,2);
plot(times, out_spk_no_stdp);
title("Output Spike Train Without STDP");
xlabel("time (ms)");
ylabel("Spike");
subplot(1,3,3);
plot(times, out_spk_stdp);
title("Output Spike Train With STDP");
xlabel("time (ms)");
ylabel("Spike");
figure();
subplot(1,2,1);
x = 1:length(epsc);
plot(x, epsc, x(loc_max_epsc), epsc(loc_max_epsc), 'r*');
title("EPSC Peaks");
xlabel("100 ms time interval");
ylabel("EPSC (Fraction Change)");
subplot(1,2,2);
stem(out_spk_stdp);
hold on;
plot(epsc_pks);
title("output spike train with EPSC peaks");
xlabel("Time");
legend("output spike", "epsc peaks");
% raster_plot(spks_pre_post *dt, time_len);