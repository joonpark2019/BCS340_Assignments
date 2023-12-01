function div = kl_div(probs_1, probs_2)
    assert (length(probs_1) == length(probs_2));
    probs_1(probs_1 == 0) = 1;
    probs_2(probs_2 == 0) = 1;
    % p_1_p_2 = probs_1./probs_2;
    div = sum(probs_1.*log2(probs_1) - probs_1.*log2(probs_2), "all");

end