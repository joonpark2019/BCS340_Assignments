function output = stim_v2(resol, rsize, num_dots)
    % resol= 0.1;
    %rsize= 4.0;
    rspace= -rsize:resol:rsize;
    mu = floor(length(rspace) / 2);
    sample_ind = floor(repmat(mu, 4, 1) + floor(length(rspace)/5)*randn(4, num_dots));
    sample_ind = min(max(sample_ind, 1), length(rspace));
    %disp(sample_ind);

    output = zeros(length(rspace), length(rspace));

    output(sub2ind(size(output),sample_ind(1, :),sample_ind(2, :))) = 1;
    output(sub2ind(size(output),sample_ind(3, :),sample_ind(4, :))) = -1;

    %output = imresize(output, [length(rspace), length(rspace)]);
    

end