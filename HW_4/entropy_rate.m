function s = entropy_rate(probs) % probs is an array of all spikes
                                    % each element represents a spike train
    % select non-zero elements
    p_n = probs(probs > 0);
    s = -1 * sum(p_n.*log2(p_n), "all");
    
end