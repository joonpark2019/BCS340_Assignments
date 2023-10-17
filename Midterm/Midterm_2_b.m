
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');

dt = 0.01;
time_interval = 100; % [ms]

i_inj_factor = [0.1, 20, 50, 100, 150, 200];

for i = 1:length(i_inj_factor)
    i_inj = i_inj_factor(i)*ones(floor(time_interval/dt), 1);
    v_m = hodkin_huxley(i_inj, time_interval);
    TF = islocalmax(v_m);
    disp(sum(TF));
    % disp(find(TF));
    t = dt:dt:time_interval;
    subplot(1, length(i_inj_factor), i);
    plot(t, v_m, t(TF), v_m(TF),'r*');
    

end


