clear all, clc, close all;



a_fast = 0.02; b_fast = 0.2; c_fast = -65; d = 2;
a_burst = 0.02; b_burst = 0.2; c_burst = -50; 
I = 10;
time = 500;
v_fast = ik_neuron(I, time, a_fast, b_fast, c_fast, d);
v_burst = ik_neuron(I, time, a_burst, b_burst, c_burst, d);
figure();
subplot(1,2,1);
plot(v_fast);
subplot(1,2,2);
plot(v_burst);

loc_max_f = islocalmax(v_fast);
loc_max_b = islocalmax(v_burst);


sigma = 10;
gaussian_filter = normpdf(-3*sigma:3*sigma, 0, sigma);

firing_rate_f = conv2(loc_max_f, gaussian_filter, 'same');
firing_rate_b = conv2(loc_max_b, gaussian_filter, 'same');
figure();
subplot(1,2,1);
plot(firing_rate_f);
subplot(1,2,2);
plot(firing_rate_b);

