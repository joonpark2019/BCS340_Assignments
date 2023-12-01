function div = cross_entropy(probs_1, probs_2)
    assert (length(probs_1) == length(probs_2));
    
    probs_2 = probs_2 + 0.00001;
    probs_2 = probs_2(probs_1 > 0);
    probs_1 = probs_1(probs_1 > 0);
    probs_2 = probs_2 ./ sum(probs_2, "all");
    % p_1_p_2 = probs_1./probs_2;
    div = -1*sum(probs_1.*log2(probs_2), "all");

end