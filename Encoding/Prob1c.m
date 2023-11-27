clear all, clc, close all

rng("default")

filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

num_trials = 100;

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
correlations = zeros(1, num_trials);
L = zeros(1, num_trials);
precision = zeros(1, num_trials);
responses = zeros(length(filt_space), length(filt_space), num_trials);
stims = zeros(length(filt_space), length(filt_space), num_trials);

for i=1:num_trials
    stim = stim_v2(resol, filter_size, 30);
    response = stim .* g;
    
    stims(:,:,i) = stim;
    
    L(i) = sum(response, "all");

end


%%%%%%%%%%%%%%%%%%%%%%%%%% Histogram construction for correlations:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


max_L = max(L, [], "all"); % 500 ms maximum isi
min_L = min(L, [], "all");
binSize = (abs(max_L) + abs(min_L)) / 100;
x = min_L:binSize:max_L;
disp("Maximum Linear Response:");
disp(max_L);
disp("Minmum Linear Response:");
disp(min_L);


hist_L = hist(L, x);

bar(x, hist_L);
title("Linear Response Histogram")
xlabel("Linear Response Values")
ylabel("Frequency")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Pixelwise Sum:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin_L] = min(L);
 [argvalmax, argmax_L] = max(L);

 min_stim_L = stims(:,:,argmin_L);
 max_stim_L = stims(:,:,argmax_L);

%%%%%%%%%%%%%%%%%%%%%%%%% Plot the Minimal, Maximal Repsonses:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure();

subplot(1,2,1)
imagesc(min_stim_L)
colormap('gray')
colorbar
title("Minimally Activating STIM")
subplot(1,2,2)
imagesc(max_stim_L)
colormap('gray')
colorbar
title("Maximally Activating STIM")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[L, sortIdx_L] = sort(L, 'descend');
responses_L = responses(:,:, sortIdx_L);

avg_min_L = sum(responses_L(:,:,80:end), 3);
avg_max_L = sum(responses_L(:,:,1:20), 3);
