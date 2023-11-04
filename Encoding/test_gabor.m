clear all, clc, close all


filter_size = 4.0;
resol = 0.05;
g = gaborFilter(filter_size , 0.3, 0.3, 1.0, 1.0, pi/6, 1.0, 1.0);
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);
figure();
pcolor(xx, yy, g);

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
