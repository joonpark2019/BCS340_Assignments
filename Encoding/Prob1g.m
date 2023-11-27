clear all, clc, close all


filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

num_trials = 100;

rng("default");

%%%%%%%%% Construction of the Receptive Field: %%%%%%%%%%%%%

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);

%%%%%%%%%%%%%%%%%%%%%%%%% Simply use more points: %%%%%%%%%%%%%%%%%%%%




g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
sample_stim = stim_v2(resol, filter_size, 30);



L_2 = zeros(1, num_trials);
precision_2 = zeros(1, num_trials);
responses_2 = zeros(length(filt_space), length(filt_space), num_trials);
stimuli_2 = zeros(length(filt_space), length(filt_space), num_trials);

%%%%%%%%% Run Trials on different Stimuli: %%%%%%%%%%%%%


for i=1:num_trials
    stim = stim_v2(resol, filter_size, 100);
    %stim = gaussianFilter(stim, filter_size, sig_opt, sig_opt);
    stimuli_2(:,:,i) = stim;
    correlations_2(i) = corr_2(stim, g);
    response = stim.*g;
    L_2(i) = sum(response, "all");
    precision_2(i) = avg_precision(stim, g);
end


%%%%%%%%%%%%%%%%%%%%%%%%%% Histogram construction for correlations:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


max_L_2 = max(L_2, [], "all"); % 500 ms maximum isi
min_L_2 = min(L_2, [], "all");
disp("Maximal Linear Response");
disp(max_L_2);
disp("Minimal Linear Response");
disp(min_L_2);

binSize = (abs(max_L_2) + abs(min_L_2)) / 100;
x_2 = min_L_2:binSize:max_L_2;

hist_L_2 = hist(L_2, x_2);
figure();
bar(x_2, hist_L_2);
title("Linear Response Histogram")
xlabel("Linear Response Values")
ylabel("Frequency")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Pixelwise Sum:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[argvalmin_2, argmin_L_2] = min(L_2);
[argvalmax_2, argmax_L_2] = max(L_2);

min_stim_L_2 = stimuli_2(:,:,argmin_L_2);
max_stim_L_2 = stimuli_2(:,:,argmax_L_2);

figure();
subplot(1,2,1)
imagesc(min_stim_L_2)
colormap('gray')
colorbar
title("Minimally Activating STIM (Linear Response)")
subplot(1,2,2)
imagesc(max_stim_L_2)
colormap('gray')
colorbar
title("Maximally Activating STIM (Linear Response)")


[L_2, sortIdx_L_2] = sort(L_2, 'descend');
responses_L_2 = stimuli_2(:,:, sortIdx_L_2);

avg_min_L_2 = sum(responses_L_2(:,:,80:end), 3);
avg_max_L_2 = sum(responses_L_2(:,:,1:20), 3);

figure()
subplot(1,2,1)
imagesc(avg_min_L_2)
colormap('gray')
colorbar
title("Average of 20 Minimally Activating STIMs (Linear Response)")
subplot(1,2,2)
imagesc(avg_max_L_2)
colormap('gray')
colorbar
title("Average of 20 Maximally Activating STIMs (Linear Response)")





