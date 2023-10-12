clear all, clc, close all

fr_mean = 500/1000;

T = 1/fr_mean;

ns = 100;
time = 100;

isi = -T.*log(rand(ns,1));
spk_times = cumsum(isi);
%spk_times(spk_times > time) = 0;
%spk_times = find(spk_times);

dt = 0.1;
spks = floor(spk_times / 0.1);

spk_train = zeros(1, floor(time/dt));
spk_train(spks) = 1;
t=1:time/dt; t = dt * t;
plot(spk_train);

isi_reg = (1/fr_mean).*ones(ns,1);
spk_times_reg = cumsum(isi_reg);
spk_times_reg(spk_times_reg > time) = 0;
spk_times_reg = find(spk_times);

    %convert times in ms to indices
spks_reg = floor(spk_times_reg / 0.1);

spk_output = zeros(1, floor(time/dt));
spk_output(spks_reg) = 1;
t=1:(time/dt); t = dt * t;
%plot(t, sample);
