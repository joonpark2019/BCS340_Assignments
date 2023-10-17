
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 100; % [ms]
i_inj = 10*ones(floor(time_interval/dt), 1);
v_m = hodkin_huxley(i_inj, time_interval);
t = dt:dt:time_interval;
plot(t, v_m);