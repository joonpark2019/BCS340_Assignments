clear all, clc, close all


filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

num_trials = 100;

rng("default")

%%%%%%%%% Construction of the Receptive Field: %%%%%%%%%%%%%

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);

%%%%%%%%% Initialize arrays for storage: %%%%%%%%%%%%%
correlations = zeros(1, num_trials);
L = zeros(1, num_trials);
precision = zeros(1, num_trials);
% responses = zeros(length(filt_space), length(filt_space), num_trials);
stimuli = zeros(length(filt_space), length(filt_space), num_trials);

%%%%%%%%% Run Trials on different Stimuli: %%%%%%%%%%%%%


for i=1:num_trials
    stim = stim_v2(resol, filter_size, 30);
    response = stim .* g;
    % responses(:,:, i) = response;
    stimuli(:,:,i) = stim;
    correlations(i) = corr_2(stim, g);
    L(i) = sum(response, "all");
    precision(i) = avg_precision(stim, g);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max correlation:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin] = min(correlations);
 [argvalmax, argmax] = max(correlations);

 min_stim = stimuli(:,:,argmin);
 max_stim = stimuli(:,:,argmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Linear response (pixel-wise product sum):  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin_L] = min(L);
 [argvalmax, argmax_L] = max(L);

 min_stim_L = stimuli(:,:,argmin_L);
 max_stim_L = stimuli(:,:,argmax_L);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max correlation:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin] = min(correlations);
 [argvalmax, argmax] = max(correlations);

 min_stim = stimuli(:,:,argmin);
 max_stim = stimuli(:,:,argmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Precision:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin_p] = min(precision);
 [argvalmax, argmax_p] = max(precision);

 min_stim_p = stimuli(:,:,argmin_p);
 max_stim_p = stimuli(:,:,argmax_p);

%%%%%%%%%%%%%%%%%%%%%%%%% Plot the Minimal, Maximally Activating STIMs:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure();
subplot(3,2,1)
imagesc(min_stim)
colormap('gray')
colorbar
title("Minimally Activating STIM (Correlation)")
subplot(3,2,2)
imagesc(max_stim)
colormap('gray')
colorbar
title("Maximally Activating STIM (Correlation)")

subplot(3,2,3)
imagesc(min_stim_L)
colormap('gray')
colorbar
title("Minimally Activating STIM (Linear Response)")
subplot(3,2,4)
imagesc(max_stim_L)
colormap('gray')
colorbar
title("Maximally Activating STIM (Linear Response)")
subplot(3,2,5)
imagesc(min_stim_p)
colormap('gray')
colorbar
title("Minimally Activating STIM (Precision)")
subplot(3,2,6)
imagesc(max_stim_p)
colormap('gray')
colorbar
title("Maximally Activating STIM (Precision)")


%%%%%%%%%%%%%%%%%%% Find Sum of 20 Minimally, Maximaly Activating STIMs%%%%%%%%%%%%%%%%%%%%%%%%%

[L, sortIdx_L] = sort(L, 'descend');
responses_L = stimuli(:,:, sortIdx_L);

%% average the STIMs according to linear response:
avg_min_L = sum(responses_L(:,:,80:end), 3) / 20;
avg_max_L = sum(responses_L(:,:,1:20), 3) / 20;

[correlations, sortIdx_corr] = sort(correlations, 'descend');
responses_corr = stimuli(:,:, sortIdx_corr);

%% average the STIMs according to correlation coefficient:
avg_min_corr = sum(responses_corr(:,:,80:end), 3) / 20;
avg_max_corr = sum(responses_corr(:,:,1:20), 3) / 20;

[argvalmin, argmin_p] = min(precision);
[argvalmax, argmax_p] = max(precision);

min_stim_p = stimuli(:,:,argmin_p);
max_stim_p = stimuli(:,:,argmax_p);

[precision, sortIdx_p] = sort(precision, 'descend');
responses_p = stimuli(:,:, sortIdx_p);

%% average the STIMs according to precision:
avg_min_p = sum(responses_p(:,:,80:end), 3) / 20;
avg_max_p = sum(responses_p(:,:,1:20), 3) / 20;


figure()
subplot(3,2,1)
imagesc(avg_min_L)
colormap('gray')
colorbar
title("Average of 20 Minimally Activating STIMs (Linear Response)")
subplot(3,2,2)
imagesc(avg_max_L)
colormap('gray')
colorbar    
title("Average of 20 Maximally Activating STIMs (Linear Response)")
subplot(3,2,3)
imagesc(avg_min_corr)
colormap('gray')
colorbar
title("Average of 20 Maximally Activating STIMs (Correlation)")
subplot(3,2,4)
imagesc(avg_max_corr)
colormap('gray')
colorbar
title("Average of 20 Maximally Activating STIMs (Correlation)")
subplot(3,2,5)
imagesc(avg_min_p)
colormap('gray')
colorbar
title("Average of 20 Maximally Activating STIMs (Precision)")
subplot(3,2,6)
imagesc(avg_max_p)
colormap('gray')
colorbar
title("Average of 20 Maximally Activating STIMs (Precision)")
