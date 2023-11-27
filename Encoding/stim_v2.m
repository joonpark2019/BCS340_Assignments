function output = stim_v2(resol, rsize, num_dots)
    
    rspace= -rsize:resol:rsize;
    mu = floor(length(rspace) / 2);
    sample_ind_pos = floor(repmat(mu, 2, 1) + floor(length(rspace)/5)*randn(2, num_dots));
    
    sample_ind_neg = floor(repmat(mu, 2, 1) + floor(length(rspace)/5)*randn(2, num_dots));
    
    %prevents overlap between indices for positive +1 dots and -1 dots
    overlap_msk = sample_ind_pos == sample_ind_neg;    
    sample_ind_pos(overlap_msk) = sample_ind_pos(overlap_msk) + 1; 

    sample_ind_pos = min(max(sample_ind_pos, 1), length(rspace));
    sample_ind_neg = min(max(sample_ind_neg, 1), length(rspace));

    output = zeros(length(rspace), length(rspace));

    output(sub2ind(size(output),sample_ind_pos(1, :),sample_ind_pos(2, :))) = 1;
    output(sub2ind(size(output),sample_ind_neg(1, :),sample_ind_neg(2, :))) = -1;


end