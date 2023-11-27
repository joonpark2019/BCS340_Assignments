function [n, probs] = prob_rate(num_spks)
    n = min(num_spks, [], "all"):1:max(num_spks, [], "all");
    prob_dist = hist(num_spks, n);
    probs = prob_dist / (sum(prob_dist, "all") + 0.001);
    %disp(sum(probs, "all"));
    assert(sum(probs, "all") <= 1);

    % verify that sum(probs == 1)

end