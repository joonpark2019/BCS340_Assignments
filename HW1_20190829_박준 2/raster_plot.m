
function raster_plot(sptimes, time_interval)
    
    figure('Units','normalized','Position',[0 0 .3 1])
    ax = subplot(4,1,1); hold on
    
    % For all trials...
    for iTrial = size(sptimes, 1):-1:1
                      
        spks            = sptimes(iTrial, :);         % Get all spikes of respective trial    
        spks            = spks(1:find(spks, 1, 'last'));
 
        xspikes         = repmat(spks,3,1);         % Replicate array
        yspikes      	= nan(size(xspikes));       % NaN array
        
        if ~isempty(yspikes)
            yspikes(1,:) = iTrial-1;                % Y-offset for raster plot
            yspikes(2,:) = iTrial;
        end
        
        plot(xspikes, yspikes, 'Color', 'k')
    end
    
    ax.XLim             = [0 time_interval];
    ax.YLim             = [0 size(sptimes, 1)];
    ax.XTick            = [0:100:time_interval]; 
    
    ax.XLabel.String  	= 'Time [ms]';
    ax.YLabel.String  	= 'Trials';
    title("Raster Plot");

end