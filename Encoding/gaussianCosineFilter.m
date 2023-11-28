
function output = gaussianCosineFilter(image, rsize, sig_x, sig_y, lambda_x, lambda_y)
    resol= 0.5;
    rspace= -rsize:resol:rsize;
    [xx, yy] = meshgrid(rspace, rspace);
    
    g = (1/sqrt(2*pi*sig_x*sig_y)) * exp(- (xx).^2/(2*sig_x^2) - (yy).^2/(2*sig_y^2))*cos(((2*pi) / lambda_x)*xx + ((2*pi) / lambda_y)*yy - (3*pi/2));
    
    output = conv2(image, g, "same");
    
end
