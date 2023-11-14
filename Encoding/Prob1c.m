clear all, clc, close all


filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);


g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
correlations = zeros(1, 100);
L = zeros(1, 100);
responses = zeros(length(filt_space), length(filt_space), 100);
for i=1:100
    stim = stim_v2(resol, filter_size, 30);
    response = stim .* g;
    responses(:,:, i) = response;
    correlations(i) = corr_2(response, g);
    L(i) = sum(response, "all");
end


correlations = abs(correlations);
binSize = 0.001;   % 1 ms bins
max_corr = max(correlations, [], "all"); % 500 ms maximum isi
x = 0:binSize:max_corr;

histogram = hist(correlations, x);
% histogram = histogram / sum(histogram) / binSize; % normalize by dividing by spike number
figure();
bar(x, histogram);
title("Correlation Histogram")
% xlabel('Interspike interval (1 ms bins)');
% ylabel('Probability');


binSize = 0.1;   % 1 ms bins
max_L = max(L, [], "all"); % 500 ms maximum isi
min_L = min(L, [], "all");
x = min_L:binSize:max_L;

hist_L = hist(L, x);
% histogram = histogram / sum(histogram) / binSize; % normalize by dividing by spike number
figure();
bar(x, hist_L);
title("Linear Response Histogram")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max correlation:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin] = min(correlations);
 [argvalmax, argmax] = max(correlations);

 min_stim = responses(:,:,argmin);
 max_stim = responses(:,:,argmax);

figure();
subplot(1,2,1)
imagesc(min_stim)
colormap('gray')
colorbar
subplot(1,2,2)
imagesc(max_stim)
colormap('gray')
colorbar
title("Correlations")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Response:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [argvalmin, argmin_L] = min(L);
 [argvalmax, argmax_L] = max(L);

 min_stim_L = responses(:,:,argmin_L);
 max_stim_L = responses(:,:,argmax_L);

figure();
subplot(1,2,1)
imagesc(min_stim_L)
colormap('gray')
colorbar
subplot(1,2,2)
imagesc(max_stim_L)
colormap('gray')
colorbar
title("Linear Responses")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[L, sortIdx] = sort(L, 'descend');
responses = responses(:,:, sortIdx);

avg_response_min = sum(responses(:,:,80:end), 3);
avg_response_max = sum(responses(:,:,1:20), 3);

figure()
subplot(1,2,1)
imagesc(avg_response_min)
colormap('gray')
colorbar
subplot(1,2,2)
imagesc(avg_response_max)



