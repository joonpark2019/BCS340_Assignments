clear all, clc, close all


filter_size = 25.0;
resol = 0.5;
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);

num_trials = 100;
rng("default");

%%%%%%%%% Construction of the Receptive Field: %%%%%%%%%%%%%

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
sample_stim = stim_v2(resol, filter_size, 30);


fft_g = abs(fftshift(fft2(g)));
[M_g,I_g] = max(fft_g,[],"all","linear");
[dim1, dim2] = ind2sub(size(fft_g),I_g);

sigma = [0.5, 2.0, 4.0];
figure('Renderer', 'painters', 'Position', [10 10 1500 400]);

gaussian_blur_1_1 = gaussianFilter(sample_stim, filter_size, sigma(1), sigma(1));
gaussian_blur_1_2 = gaussianCosineFilter(sample_stim, filter_size, sigma(1), sigma(1), pi*20, pi*40);
fft_gb_1_1 = abs(fftshift(fft2(gaussian_blur_1_1)));
fft_gb_1_2 = abs(fftshift(fft2(gaussian_blur_1_2)));
gaussian_blur_2_1 = gaussianFilter(sample_stim, filter_size, sigma(2), sigma(2));
gaussian_blur_2_2 = gaussianCosineFilter(sample_stim, filter_size, sigma(2), sigma(2), pi*20, pi*40);
fft_gb_2_1 = abs(fftshift(fft2(gaussian_blur_2_1)));
fft_gb_2_2 = abs(fftshift(fft2(gaussian_blur_2_2)));
gaussian_blur_3_1 = gaussianFilter(sample_stim, filter_size, sigma(3), sigma(3));
gaussian_blur_3_2 = gaussianCosineFilter(sample_stim, filter_size, sigma(3), sigma(3), pi*20, pi*40);
fft_gb_3_1 = abs(fftshift(fft2(gaussian_blur_3_1)));
fft_gb_3_2 = abs(fftshift(fft2(gaussian_blur_3_2)));

subplot(2,2,1)
imagesc(fft_g)
title("Frequency Profile of the Receptive Field")
colorbar
subplot(2,2,2)
imagesc(fft_gb_1_1)
title("Frequency Profile of Gaussian Blur (Sigma=0.5)")
colorbar
subplot(2,2,3)
imagesc(fft_gb_2_1)
title("Frequency Profile of Gaussian Blur (Sigma=2.0)")
colorbar
subplot(2,2,4)
imagesc(fft_gb_3_1)
title("Frequency Profile of Gaussian Blur (Sigma=4.0)")
colorbar


figure('Renderer', 'painters', 'Position', [1000 10 1500 400]);
subplot(1,2,1)
imagesc(fft_g)
title("Frequency Profile of the Receptive Field")
colorbar
% subplot(2,2,2)
% imagesc(fft_gb_1_2)
% title("Frequency Profile of Gaussian Cosine Blur (Sigma=0.5)")
% colorbar
subplot(1,2,2)
imagesc(fft_gb_2_2)
title("Frequency Profile of Gaussian Cosine Blur (Sigma=2.0)")
colorbar
% subplot(2,2,4)
% imagesc(fft_gb_3_2)
% title("Frequency Profile of Gaussian Cosine Blur (Sigma=4.0)")
% colorbar

%%%%%%% Optimal Value is set to 2.0: %%%%%%%%%%
sig_opt = 2.0;


L_1 = zeros(1, num_trials); L_2 = zeros(1, num_trials);
precision = zeros(1, num_trials);
responses = zeros(length(filt_space), length(filt_space), num_trials);
stimuli_1 = zeros(length(filt_space), length(filt_space), num_trials);
stimuli_2 = zeros(length(filt_space), length(filt_space), num_trials);

%%%%%%%%% Run Trials on different Stimuli: %%%%%%%%%%%%%


for i=1:num_trials
    stim = stim_v2(resol, filter_size, 30);
    stim_1 = gaussianFilter(stim, filter_size, sig_opt, sig_opt);
    stim_2 = gaussianCosineFilter(stim, filter_size, sig_opt, sig_opt, pi*20, pi*40);
    stimuli_1(:,:,i) = stim_1;
    stimuli_2(:,:,i) = stim_2;
    L_1(i) = sum(stim_1.*g, "all");
    L_2(i) = sum(stim_2.*g, "all");
end


%%%%%%%%%%%%%%%%%%%%%%%%%% Histogram construction for Linear Response:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


max_L_1 = max(L_1, [], "all");
min_L_1 = min(L_1, [], "all");
disp("Maximum Linear Response:");
disp(max_L_1);
disp("Minmum Linear Response:");
disp(min_L_1);


max_L_2 = max(L_2, [], "all");
min_L_2 = min(L_2, [], "all");
disp("Maximum Linear Response (with GaussianCosine Filter):");
disp(max_L_2);
disp("Minmum Linear Response (with GaussianCosine Filter):");
disp(min_L_2);


binSize_1 = (abs(max_L_1) + abs(min_L_1)) / 100;
x_1 = min_L_1:binSize_1:max_L_1;

binSize_2 = (abs(max_L_2) + abs(min_L_2)) / 100;
x_2 = min_L_2:binSize_2:max_L_2;

hist_L_1 = hist(L_1, x_1);
hist_L_2 = hist(L_2, x_2);
figure();
bar(x_1, hist_L_1);
title("Linear Response Histogram (Gaussian)")
xlabel("Linear Response Values")
ylabel("Frequency")

figure();
bar(x_2, hist_L_2);
title("Linear Response Histogram (GaussianCosine)")
xlabel("Linear Response Values")
ylabel("Frequency")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min, Max Pixelwise Sum:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[argvalmin_1, argmin_L_1] = min(L_1);
[argvalmax_1, argmax_L_1] = max(L_1);
[argvalmin_2, argmin_L_2] = min(L_2);
[argvalmax_2, argmax_L_2] = max(L_2);
min_stim_L_1 = stimuli_1(:,:,argmin_L_1);
max_stim_L_1 = stimuli_1(:,:,argmax_L_1);

min_stim_L_2 = stimuli_2(:,:,argmin_L_2);
max_stim_L_2 = stimuli_2(:,:,argmax_L_2);

figure();
subplot(2,2,1)
imagesc(min_stim_L_1)
colormap('gray')
colorbar
title("Minimally Activated Response")
subplot(2,2,2)
imagesc(max_stim_L_1)
colormap('gray')
colorbar
title("Maximally Activated Response")
subplot(2,2,3)
imagesc(max_stim_L_2)
colormap('gray')
colorbar
title("Maximally Activated Response")
subplot(2,2,4)
imagesc(max_stim_L_2)
colormap('gray')
colorbar
title("Maximally Activated Response")


[L_1, sortIdx_L_1] = sort(L_1, 'descend');
responses_L_1 = stimuli_1(:,:, sortIdx_L_1);

avg_min_L_1 = sum(responses_L_1(:,:,80:end), 3);
avg_max_L_1 = sum(responses_L_1(:,:,1:20), 3);

[L_2, sortIdx_L_2] = sort(L_2, 'descend');
responses_L_2 = stimuli_2(:,:, sortIdx_L_2);

avg_min_L_2 = sum(responses_L_2(:,:,80:end), 3);
avg_max_L_2 = sum(responses_L_2(:,:,1:20), 3);



figure()
subplot(2,2,1)
imagesc(avg_min_L_1)
colormap('gray')
colorbar
title("Average of Minimally Activated Responses (Gaussian)")
subplot(2,2,2)
imagesc(avg_max_L_1)
title("Average of Maximally Activated Responses (Gaussian)")
subplot(2,2,3)
imagesc(avg_min_L_2)
colormap('gray')
colorbar
title("Average of Minimally Activated Responses (GaussianCosine)")
subplot(2,2,4)
imagesc(avg_max_L_2)
title("Average of Maximally Activated Responses (GaussianCosine)")





