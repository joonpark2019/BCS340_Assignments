clear all, clc, close all


filter_size = 25.0;
resol = 0.1;
g = gaborFilter(filter_size, 10, 10, 0, 0, 7*pi/6, pi/2, pi*10);
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);
figure();
%surfc(xx, yy, g);

imagesc(filt_space,filt_space,g);  
colormap('jet');
colorbar;
% 
figure()
rand_stim = stim_v2(filter_size, 30);
rand_space = -filter_size:resol:filter_size;
imagesc(rand_space, rand_space, rand_stim);
colormap('gray');
colorbar;
colorbar;

output = g .* rand_stim;
figure()
imagesc(rand_space, rand_space, rand_stim);


gaussian_blur = gaussianFilter(rand_stim, filter_size, 0.5, 0.5);
figure()
imagesc(rand_space, rand_space, gaussian_blur);

% original_img = imread("monkey.jpg");
% original_img = original_img(500:550, 600:770, :);
% imshow(original_img);
% filteredRGB = convfft(original_img, g);
% figure, imshow(filteredRGB)
% 
% 
% d = drifting_grating(1.0, 0, 1.0, 5, 2, 5.0, 500);
% f_rate = 5;
% 
% for i=1:size(d,3)
%     imagesc(d(:,:,i))
%     pause(1/f_rate);
% end
%visualize_drifting_grating(1.0, pi/6, 1.0, 1, 2, 5.0, 500);
