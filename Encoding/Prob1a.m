clear all, clc, close all

filter_size = 25.0;
resol = 0.5;

%%% Gabor filter with no rotation


%%%% Show Gabor filter rotated at an angle with a 

g = gaborFilter(resol, filter_size, 10, 10, 0, 0, pi/6, 3*pi/2, pi*10);
filt_space= -filter_size :resol:filter_size ;
[xx, yy] = meshgrid(filt_space , filt_space);
figure();

imagesc(filt_space,filt_space,g);  
title("Receptive Field")
colormap('jet');
colorbar;


angles = [0, pi/4, 3*pi/4, 5*pi/4, 7*pi/4, 2*pi];
g_filters = zeros(length(filt_space), length(filt_space), length(angles));
for i=1:length(angles)
    g_filters(:,:,i) = gaborFilter(resol, filter_size, 10, 10, 0, 0, angles(i), 3*pi/2, pi*10);
end

figure()
for i=1:length(angles)
    subplot(2,3, i)
    imagesc(filt_space,filt_space,g_filters(:,:,i))
    title(['rotation angle = ' num2str(rad2deg(angles(i)))])
    colormap('jet')
    colorbar

end

