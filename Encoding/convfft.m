% output is at most the size of img (filter must be smaller in both
% dimensions than img)

function output = convfft(img, filter)
    w_im = size(img, 1); h_im = size(img, 2);
    w_filt = size(filter, 1); h_filt = size(filter, 2);
    N = max(size(img));
    output = abs(ifft2(fft2(img, 2*N-1, 2*N-1).*fft2(filter, 2*N-1, 2*N-1)));
    output = output(floor(w_filt/2)+1:floor(w_filt/2) + w_im, floor(h_filt/2)+1:floor(h_filt/2)+h_im);
end
