clear all, clc, close all;



a_fast = 0.1; b_fast = 0.2; c_fast = -65; d_fast = 13;
a_burst = 0.02; b_burst = 0.2; c_burst = -50; d_burst = 3;
I = 10;
time = 500;
v_fast = ik_neuron(I, time, a_fast, b_fast, c_fast, d_fast, []);
v_burst = ik_neuron(I, time, a_burst, b_burst, c_burst, d_burst, []);
figure();
subplot(1,2,1);
plot(0:1:time, v_fast);
title("Fast Spiking Neuron Spike Train");
xlabel("Time (ms)");
ylabel("Voltage (mV)");
subplot(1,2,2);
plot(0:1:time, v_burst);
title("Bursting Neuron Spike Train");
xlabel("Time (ms)");
ylabel("Voltage (mV)");

loc_max_f = islocalmax(v_fast);
loc_max_b = islocalmax(v_burst);


sigma = 20;
% gaussian_filter = normpdf(-3*sigma:3*sigma, 0, sigma);

gau_sdf = conv2(loc_max_f,gausswin(20),'same');
gau_sdf_2 = conv2(loc_max_b,gausswin(20),'same');
figure();
subplot(1,2,1);
plot(0:1:time,gau_sdf);
title("Instantaneous Firing Rate for Fast, Regular Spiking");
xlabel("time (ms)");
ylabel("Filtered Response");
subplot(1,2,2);
plot(0:1:time,gau_sdf_2);
title("Instantaneous Firing Rate for Bursting");
xlabel("time (ms)");
ylabel("Filtered Response");

