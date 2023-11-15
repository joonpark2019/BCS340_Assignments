function output = stim(rsize, num_dots)
    resol= 1;
    %rsize= 4.0;
    rspace= -rsize:resol:rsize;

    sample_ind = ceil(length(rspace)*rand(4, num_dots));

    output = zeros(length(rspace), length(rspace));

    output(sub2ind(size(output),sample_ind(1, :),sample_ind(2, :))) = 1;
    output(sub2ind(size(output),sample_ind(3, :),sample_ind(4, :))) = -1;

    %output = imresize(output, [length(rspace), length(rspace)]);
    

end