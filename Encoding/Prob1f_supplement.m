clear all, clc, close all

resol= 0.5;
rsize = 25.0;
rspace= -rsize:resol:rsize;
[xx, yy] = meshgrid(rspace, rspace);
    
lambda_x = 10*pi;
lambda_y = 20*pi;

g = cos(((2*pi) / lambda_x)*xx + ((2*pi) / lambda_y)*yy - (3*pi)/2);
figure();
imagesc(g)
title("Cosine Term of Gaussian Cosine Filter")
colormap('gray')