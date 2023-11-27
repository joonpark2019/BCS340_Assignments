
clear all, clc, close all

 addpath(genpath("./utils"));

%fix random seed:
rng('default');


dt = 0.01;
t = dt:dt:2000;
threshold_current = 6.13; %meaningless init
A = (10 - threshold_current) / 2;
B_1 = 2*pi/200;
B_2 = 2*pi/2000;
C = (10 + threshold_current) / 2;
i_sin_1 = A*sin(B_1.*t) + C;
i_sin_2 = A*sin(B_2.*t) + C;

v_m_1 = hodkin_huxley(i_sin_1, 2000);
spk_t_1 = digitize(v_m_1);

v_m_2 = hodkin_huxley(i_sin_2, 2000);
spk_t_2 = digitize(v_m_2);


binSize = 0.5;                                           % 1 ms bins
max_isi = 50;
x = 1:binSize:max_isi;

%% Generate Interspike Histograms:
isi_sample_1 = dt * diff(find(spk_t_1));
isi_sample_1 = reshape(isi_sample_1.',1,[]);
intervalDist_1 = hist(isi_sample_1(isi_sample_1 < max_isi), x);
intervalDist_1 = intervalDist_1 / sum(intervalDist_1) / binSize; % normalize by dividing by spike number

isi_sample_2 = dt * diff(find(spk_t_2));
isi_sample_2 = reshape(isi_sample_2.',1,[]);
intervalDist_2 = hist(isi_sample_2(isi_sample_2 < max_isi), x);
intervalDist_2 = intervalDist_2 / sum(intervalDist_2) / binSize; % normalize by dividing by spike number

% vis_hh_sample_mod(dt, 2000, dt, i_sin_1);
% vis_hh_sample(dt, 2000, dt, i_sin_2);

figure('Position', [50, 50, 1000, 900]);

subplot(1,2,1);
bar(x, intervalDist_1)
title("Inter Spike Interval Histogram, Period = 200ms")
xlabel('Interspike interval (0.5 ms bins)');
ylabel('Probability');
subplot(1,2,2);
bar(x, intervalDist_2)
title("Inter Spike Interval Histogram, Period = 2000ms")
xlabel('Interspike interval (0.5 ms bins)');
ylabel('Probability');

disp("Refractory Period for Period = 200 ms (in ms)");
disp(min(isi_sample_1));
disp("Refractory Period for Period = 2000 ms (in ms)");
disp(min(isi_sample_2));

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION DEFINITIONS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function spk_train = digitize(voltages)
    maxima = islocalmax(voltages);
    max_indx = find(maxima);

    minima = islocalmin(voltages);
    min_indx = find(minima);

    voltage_range = max(voltages(maxima)) - min(voltages(minima));
    len = min(length(max_indx), length(min_indx));
    max_indx = max_indx(1:len);
    min_indx = min_indx(1:len);
    indices = voltages(max_indx) - voltages(min_indx) > 0.1*voltage_range;
    spks = zeros(length(voltages), 1);
    spks(max_indx(indices)) = 1;
    spk_train = spks;
    
end

