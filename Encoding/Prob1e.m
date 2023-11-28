clear all, clc, close all

rng("default")
filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
stim = stim_v2(resol, filter_size, 30);
gaussian_blur_1 = gaussianFilter(stim, filter_size, 0.1, 0.1);
gaussian_blur_2 = gaussianFilter(stim, filter_size, 4.0, 4.0);

fft_g = abs(fftshift(fft2(g)));
fft_stim = abs(fftshift(fft2(stim)));
fft_gb1 = abs(fftshift(fft2(gaussian_blur_1)));
fft_gb2 = abs(fftshift(fft2(gaussian_blur_2)));

figure();
imagesc(g);

num_samples = 10;

figure('Renderer', 'painters', 'Position', [10 10 600 1400])
for i=1:2:2*num_samples
    stim_sample = stim_v2(resol, filter_size, 30);
    gb_1 = gaussianFilter(stim_sample, filter_size, 0.1, 0.1);
    gb_2 = gaussianFilter(stim_sample, filter_size, 4.0, 4.0);
    subplot(num_samples,2,i);
    imagesc(filt_space, filt_space, gb_1);
    title("STIM Convolved with Sigma = 0.1")
    colormap("gray");
    colorbar;
    subplot(num_samples,2,i+1);
    imagesc(filt_space, filt_space, gb_2);
    title("STIM Convolved with Sigma = 4.0")
    colormap("gray");
    colorbar;
end

figure('Renderer', 'painters', 'Position', [910 610 900 600])
subplot(2,2,1)
imagesc(fft_g)
colorbar
title("FFT plot of the Receptive Field")
subplot(2,2,2)
imagesc(fft_stim)
colorbar
title("FFT plot of the STIM")
subplot(2,2,3)
imagesc(fft_gb1)
colorbar
title("FFT plot of the STIM with Gaussian Blur (low Sigma)")
subplot(2,2,4)
imagesc(fft_gb2)
colorbar
title("FFT plot of the STIM with Gaussian Blur (high Sigma)")

