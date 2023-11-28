clear all, clc, close all


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

for i=1:num_trials
    stim = stim_v2(resol, filter_size, 30);
    response = stim .* g;
    responses(:,:, i) = response;
    correlations(i) = corr_2(response, g);
    L(i) = sum(response, "all");
    precision(i) = avg_precision(g, response);
end


%%%%%%%%%%%%%%%%%%%%%%%%%% Histogram construction for correlations:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

correlations = abs(correlations);
max_corr = max(correlations, [], "all");
min_corr = min(correlations, [], "all");
binSize = (max_corr - min_corr) / 100;   % 1 ms bins

x = min_corr:binSize:max_corr;

hist_corr = hist(correlations, x);

max_L = max(L, [], "all"); % 500 ms maximum isi
min_L = min(L, [], "all");
binSize = (abs(max_L) + abs(min_L)) / 100;
x = min_L:binSize:max_L;

hist_L = hist(L, x);

% histogram = histogram / sum(histogram) / binSize; % normalize by dividing by spike number
% figure();
% subplot(1,2,1);
% bar(x, hist_corr);
% title("Correlation Histogram")
% xlabel('Interspike interval (1 ms bins)');
% ylabel('Probability');

bar(x, hist_L);
title("Linear Response Histogram")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max correlation:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin] = min(correlations);
 [argvalmax, argmax] = max(correlations);

 min_stim = responses(:,:,argmin);
 max_stim = responses(:,:,argmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Pixelwise Sum:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin_L] = min(L);
 [argvalmax, argmax_L] = max(L);

 min_stim_L = responses(:,:,argmin_L);
 max_stim_L = responses(:,:,argmax_L);

%%%%%%%%%%%%%%%%%%%%%%%%% Plot the Minimal, Maximal Repsonses:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure();
subplot(2,2,1)
imagesc(min_stim)
colormap('gray')
colorbar
title("Minimally Activated Response (Correlation)")
subplot(2,2,2)
imagesc(max_stim)
colormap('gray')
colorbar
title("Maximally Activated Response (Correlation)")

subplot(2,2,3)
imagesc(min_stim_L)
colormap('gray')
colorbar
title("Minimally Activated Response (Pixelwise Sum)")
subplot(2,2,4)
imagesc(max_stim_L)
colormap('gray')
colorbar
title("Maximally Activated Response (Pixelwise Sum)")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[L, sortIdx_L] = sort(L, 'descend');
responses_L = responses(:,:, sortIdx_L);

avg_min_L = sum(responses_L(:,:,80:end), 3);
avg_max_L = sum(responses_L(:,:,1:20), 3);

[correlations, sortIdx_corr] = sort(correlations, 'descend');
responses_corr = responses(:,:, sortIdx_corr);

avg_min_corr = sum(responses_corr(:,:,80:end), 3);
avg_max_corr = sum(responses_corr(:,:,1:20), 3);



[argvalmin, argmin_p] = min(precision);
[argvalmax, argmax_p] = max(precision);

min_stim_p = responses(:,:,argmin_p);
max_stim_p = responses(:,:,argmax_p);

[correlations, sortIdx_p] = sort(precision, 'descend');
responses_p = responses(:,:, sortIdx_p);

avg_min_p = sum(responses_p(:,:,80:end), 3);
avg_max_p = sum(responses_p(:,:,1:20), 3);


figure()
subplot(3,2,1)
imagesc(avg_min_L)
colormap('gray')
colorbar
title("Average of 20 Minimally Activated Responses (Pixelwise Sum)")
subplot(3,2,2)
imagesc(avg_max_L)
title("Average of 20 Maximally Activated Responses (Pixelwise Sum)")
subplot(3,2,3)
imagesc(avg_min_corr)
title("Average of 20 Maximally Activated Response (Correlation)")
subplot(3,2,4)
imagesc(avg_max_corr)
title("Average of 20 Maximally Activated Response (Correlation)")
subplot(3,2,5)
imagesc(avg_min_p)
title("Average of 20 Maximally Activated Response (Precision)")
subplot(3,2,6)
imagesc(avg_max_p)
title("Average of 20 Maximally Activated Response (Precision)")



figure();
subplot(1,2,1)
imagesc(min_stim_p)
colormap('gray')
colorbar
title("Minimally Activated Response (precision)")
subplot(1,2,2)
imagesc(max_stim_p)
colormap('gray')
colorbar
title("Maximally Activated Response (precision)")