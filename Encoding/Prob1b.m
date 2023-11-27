clear all, clc, close all


filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

rand_stim = stim_v2(resol, filter_size, 30);
rand_space = -filter_size:resol:filter_size;
imagesc(rand_space, rand_space, rand_stim);
title("Random Noise Visual Stimulus")
colormap('gray');
colorbar;

visualize_stims(resol, filter_size, 30, 10);


