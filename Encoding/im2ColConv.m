clear all, clc, close all

function convResult = im2ColConv(img, filter, stride, padding)
    

end


function b = flatten(a)
    b = zeros(1, size(a,1) * size(a,2));
    row_len = size(a,1);
    for i=1:size(a,1)
        b((i-1)*row_len + 1 :(i)*row_len) = a(i, :);
    end
end
