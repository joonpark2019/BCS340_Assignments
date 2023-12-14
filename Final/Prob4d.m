clear all, clc, close all;


a = 0.1;
b = 0.2;
c = -65;
d = 2;

a = 0.02;
b = 0.2;
c = -50;
d = 2;

a_fast = 0.1; b_fast = 0.2; c_fast = -65; d_fast = 13;
a_burst = 0.02; b_burst = 0.2; c_burst = -50;  d_burst = 3;
I = 10;
time = 500;
v_fast = ik_neuron(I, time, a_burst, b_burst, c_burst, d_burst, []);
spk_times = islocalmax(v_fast);
v_response = ik_neuron(0, time, 0.3, 0.2, -55, 8, spk_times);
plot(v_response);
