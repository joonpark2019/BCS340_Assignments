function visualize_stims(resol, rsize, num_dots, num_stims)
    %% visuzlie multiple stims --> find distribution on which the dots are closest to the gabor filter
    %% see which stims are near the gabor filter --> overlay all stims on the gabor filter

    g = gaborFilter(resol, rsize, 2*rsize / 5, 2*rsize / 5, 0, 0, pi/6, 3*pi/2, pi * (2*rsize / 5));
    rspace= -rsize:resol:rsize;
    % 
    stim_output = zeros(length(rspace), length(rspace));
    % stim_output_2 = zeros(length(rspace), length(rspace));
    for i=1:num_stims
        stim_output = stim_output + stim_v2(resol, rsize, num_dots);
    end

    stim_output = max(min(stim_output, 1), -1);
    
%% code taken from: https://kr.mathworks.com/matlabcentral/answers/476715-superimposing-two-imagesc-graphs-over-each-other
    %plot first data 
    figure();
    title('STIMS Overlaid on Gabor Filter');
    ax1 = axes; 
    im = imagesc(ax1,g); 
    im.AlphaData = 0.5; % change this value to change the background image transparency 
    axis square; 
    hold all; 
    %plot second data 
    ax2 = axes; 
    im1 = imagesc(ax2,stim_output); 
    im1.AlphaData = 0.6; % change this value to change the foreground image transparency 
    axis square; 
    %link axes 
    linkaxes([ax1,ax2]) 
    %%Hide the top axes 
    ax2.Visible = 'off'; 
    ax2.XTick = []; 
    ax2.YTick = []; 
    %add differenct colormap to different data if you wish 
    colormap(ax1,'jet') 
    colormap(ax2,'gray') 
    %set the axes and colorbar position 
    %set([ax1,ax2],'Position',[.17 .11 .685 .815]); 
    cb1 = colorbar(ax1,'Position',[.05 .11 .0675 .815]); 
    cb2 = colorbar(ax2,'Position',[.88 .11 .0675 .815]);
    

end