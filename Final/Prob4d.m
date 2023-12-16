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
v_fast = ik_neuron(I, time, a_fast, b_fast, c_fast, d_fast, []);
spk_times_f = islocalmax(v_fast);
v_burst = ik_neuron(I, time, a_burst, b_burst, c_burst, d_burst, []);
spk_times_b = islocalmax(v_burst);


%% try chattering parameters

%% chattering parameters don't work
%% u needs to be negative in order to v to increase
%% need u to decay slowly so that only synapses lead to spikes
%% must reset d to a higher value and set voltage reset to a higher value

a_param = 0.01; b_param = 0.01; 
c_param = -55; d_param = 9;

v_response_1 = ik_neuron(0, time, a_param, b_param, c_param, d_param, spk_times_f);
v_response_2 = ik_neuron(0, time, a_param, b_param, c_param, d_param, spk_times_b);
figure();
subplot(1,2,1);
plot(0:1:time, v_response_1);
title("Spike Output for Synaptic Input from Fast, Regular Spiking");
xlabel("time (ms)");
ylabel("Membrane Voltage (mV)");

subplot(1,2,2);
plot(0:1:time,v_response_2);
title("Spike Output for Synaptic Input from Bursting Spikes");
xlabel("time (ms)");
ylabel("Membrane Voltage (mV)");