% https://observatory.brain-map.org/visualcoding/stimulus/drifting_gratings
%%useful link for future

function visualize_drifting_grating(lambda, theta, phi, freq, A, rsize, time)
    d = drifting_grating(lambda, theta, phi, freq, A, rsize, time);
    figure();
    title("Drifting Grating");
    for i=1:size(d,3)
        imagesc(d(:,:,i))
        pause(1/freq);
    end

end