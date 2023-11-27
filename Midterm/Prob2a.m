
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;              % [ms]
time_interval = 100;    % [ms]
i_inj = 10*ones(floor(time_interval/dt), 1); % inject 10 uA/cm^2 current for 100 ms
v_m = hodkin_huxley(i_inj, time_interval);
t = dt:dt:time_interval;
figure();
plot(t, v_m);
xlabel("Time (ms)");
ylabel("Voltage (mV)");
title("Hodgkin Huxley Model Voltage");