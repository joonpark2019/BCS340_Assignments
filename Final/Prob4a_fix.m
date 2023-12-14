clear all, clc, close all;

I = 10;
time = 500;

%% default parameters used in the Izhikevich neuron paper: https://www.izhikevich.org/publications/spikes.pdf
a = 0.1;
b = 0.2;
c = -65;
d = 2;
times = 0:1:time;
v = ik_neuron(I, time, a, b, c, d, []);
disp("Number of spikes using default parameters:");
disp(sum(islocalmax(v)));


%% vary the parameter d to reduce rate to 50 Hz
d_final = d;
ds = d:1:20;
for d_test = ds
    v = ik_neuron(I, time, a, b, c, d_test, []);
    num_spks = sum(islocalmax(v));
    if num_spks == 25
        d_final = d_test;
        break;
    end
end


%% spikes are determined using local maxima in the membrane voltage
v = ik_neuron(I, time, a, b, c, d_final, []);
loc_max = islocalmax(v);
disp("Number of Spikes in 500 ms interval after tuning parameter d:");
disp(sum(loc_max));
figure();
plot(times, v, times(loc_max), v(loc_max), 'r*');
title("Time vs. Membrane Voltage : Fast Regular Spiking");
xlabel("time (ms)");
ylabel("Membrane Voltage (mV)");

isi = diff(find(loc_max));
max_isi = max(isi, [], "all");
min_isi = min(isi, [], "all");
bins = min_isi:1:max_isi;
figure();
bar(bins, hist(isi, bins));
title("ISI Histogram");
xlabel("interspike interval (ms)");
ylabel("Frequency");

