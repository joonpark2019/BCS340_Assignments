function d = counterphase_grating(lambda, theta, phi, freq, A, rsize, time)

    resol= 0.05;
    dt = 0.05;
    rspace= -rsize:resol:rsize;
    times = dt:dt:time;
    %disp(times);
    
    [xx, yy] = meshgrid(rspace, rspace);
    s = zeros(length(rspace), length(rspace), length(times ));
    
    %% spatial frequency and rotation:
    k = 2*pi / lambda;
    %disp(length(times));
    for i=1:length(times)
        %disp(times(i));
        s_t = A.*cos(k*xx*cos(theta) + k*yy*sin(theta) - phi).* cos(2*pi*freq*times(i));
        %disp(size(s_t));
        s(:,:,i) = s_t;
    end
    d = s;
end