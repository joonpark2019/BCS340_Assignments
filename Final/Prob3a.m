clear all, clc, close all;

delay = -100:0.1:100;
tau = 10;
kernel = 100 * (exp(-1*delay / tau).*(delay > 0) - exp(delay / tau).*(delay < 0));
figure();
plot(delay, kernel);
title("STDP");
ylabel("\Delta EPSC (%)");
xlabel("t_{post} - t_{pre} (ms)");
