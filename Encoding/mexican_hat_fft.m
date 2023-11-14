clear all, clc, close all

lb = -5;
ub = 5;
N = 1000;
%[psi,xval] = mexihat(lb,ub,N);

ric = @(t,fm)(1-2*pi()^2*fm^2*t.^2)*exp(-1*pi()^2*fm^2*t.^2); 

f_domain = fft(psi);
plot(x_val, f_domain);