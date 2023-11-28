clear all, clc, close all

filter_size = 25.0;
resol = 0.5;
g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);
figure();

gabor_fft = fft2(g, length(filt_space), length(filt_space));
surfc(xx, yy, abs(gabor_fft));

rand_stim = stim_v2(filter_size, 30);
rand_space = -filter_size:resol:filter_size;

gaussian_blur = gaussianFilter(rand_stim, filter_size, 0.5, 0.5);
gaussian_fft = fft2(gaussian_blur, length(filt_space), length(filt_space));
surfc(xx, yy, abs(gaussian_fft));