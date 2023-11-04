
function g = gaborFilter(rsize, sig_x, sig_y, x_0, y_0, theta, phi, lambda)
    resol= 0.05;
    %rsize= 4.0;
    rspace= -rsize:resol:rsize;
    [xx, yy] = meshgrid(rspace, rspace);
    %theta = pi / 6;
    
    
    %sig_x= 0.3;
    %sig_y= 1.5;
    %x_0 = 1.0; y_0 = 1.0;
    k = 2*pi / lambda;
    %phi = 1.0;
    x_theta = xx * cos(theta) + yy * sin(theta);
    y_theta = -xx * sin(theta) + yy * cos(theta);
    x_0_theta = x_0 * cos(theta) + y_0 * sin(theta);
    y_0_theta = -x_0 * sin(theta) + y_0 * cos(theta);
    
    g = (1/2*pi*sig_x*sig_y) * exp(- (x_theta  - x_0_theta).^2/2/sig_x^2 - (y_theta - y_0_theta).^2/2/sig_y^2).*cos(k*x_theta - phi);
end
