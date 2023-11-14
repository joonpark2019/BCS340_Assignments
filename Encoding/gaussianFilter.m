
function output = gaussianFilter(image, rsize, sig_x, sig_y)
    resol= 0.1;
    rspace= -rsize:resol:rsize;
    [xx, yy] = meshgrid(rspace, rspace);
    
    g = (1/sqrt(2*pi*sig_x*sig_y)) * exp(- (xx).^2/(2*sig_x^2) - (yy).^2/(2*sig_y^2));
    
    output = conv2(image, g, "same");
    
end
