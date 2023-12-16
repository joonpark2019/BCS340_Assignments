clear all, clc, close all;
rng("default");


time_len = 10000; %ms
rate_pre = 50 / 1000;
dt = 0.1;

delay = -100:dt:100;
tau = 10;

input_spk = poisson_spk_train_point(1, rate_pre, time_len, dt);

mean_rate = sum(input_spk(1, 1:floor(100/dt)), "all") / 100;
rate_post = mean_rate * (0.1);
out_spk_no_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
out_spk_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
while sum(out_spk_stdp) == 0
    out_spk_stdp = poisson_spk_train_point(1, rate_post, 100, dt);
end


epsc = zeros(1, floor(time_len / 100));
rate_post_r = 0;
time_interval = floor(100/dt);
for i=1:1:(floor(time_len / 100) - 1)
    
    t = i*time_interval;
    mean_rate = sum(input_spk(1, (t - floor(100/dt)+1):t), "all") / 100;
    spk_times_output = find(out_spk_stdp(1, (t - floor(100/dt)+1):t));

    out_spk_no_stdp = [out_spk_no_stdp, poisson_spk_train_point(1, mean_rate*0.1, 100, dt)];

    % in case there are no spikes within the 100 ms interval:
    if isempty(spk_times_output)
        out_spk_stdp = [out_spk_stdp, poisson_spk_train_point(1, rate_post_r, 100, dt)];
        continue;
    end

    mean_time = mean(spk_times_output, "all");
    avg_input_timing = mean(find(input_spk(1, (t - floor(100/dt)+1):t)), "all");
    delay = dt*(mean_time - avg_input_timing);
    STDP = (exp(-1*delay / tau).*(delay > 0) - exp(delay / tau).*(delay < 0));
    epsc(1, floor(t/(100/dt))) = STDP;
    rate_post = mean_rate * 0.1*(1 + STDP);
    rate_post_r = rate_post;
    out_spk_stdp = [out_spk_stdp, poisson_spk_train_point(1, rate_post, 100, dt)];

   
end

loc_max_epsc = epsc > 0.2;
loc_min_epsc = epsc < -0.05;
epsc_pks = zeros(1, length(out_spk_stdp));
epsc_pks(1, floor(100/dt) * find(loc_max_epsc)) = 1;
epsc_min = zeros(1, length(out_spk_stdp));
epsc_min(1, floor(100/dt) * find(loc_min_epsc)) = 1;

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
x = 100*(1:length(epsc));
plot(x, epsc, x(loc_max_epsc), epsc(loc_max_epsc), 'r*');
hold on;
plot(x, epsc, x(loc_min_epsc), epsc(loc_min_epsc), 'b*');
title("EPSC Peaks");
xlabel("time (ms)");
ylabel("EPSC (Fraction Change)");
subplot(1,2,2);
plot(times, out_spk_stdp);
hold on;
plot(times,epsc_pks, "*r");
hold on;
plot(times,epsc_min, "*b");
title("output spike train with EPSC peaks");
xlabel("Time");
legend("output spike", "epsc maxima", "epsc minima");

% 
% [c_stdp,lags_stdp] = xcorr(input_spk,out_spk_stdp,length(input_spk),'normalized');
% [c_n_stdp,lags_n_stdp] = xcorr(input_spk,out_spk_no_stdp,length(input_spk),'normalized');
% figure();
% subplot(1,2,1);
% stem(lags_stdp,c_stdp);
% subplot(1,2,2);
% stem(lags_n_stdp,c_n_stdp);
% disp(mean(c_stdp, "all"));
% disp(mean(c_n_stdp, "all"));

% raster_plot(spks_pre_post *dt, time_len);