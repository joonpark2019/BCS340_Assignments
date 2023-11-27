clear all, clc, close all
resol= 0.1;
rsize = 25;
rspace= -rsize:resol:rsize;
[xx, yy] = meshgrid(rspace, rspace);
sig_x = 0.1;
sig_y = 0.1;
g = (1/sqrt(2*pi*sig_x*sig_y)) * exp(- (xx).^2/(2*sig_x^2) - (yy).^2/(2*sig_y^2));
fft_g = abs(fft2(g));
figure();
subplot(1,2,1)
imagesc(g)
colorbar
subplot(1,2,2)
imagesc(fft_g)
colorbar
    