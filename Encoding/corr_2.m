function corr = corr_2(A,B)
    num = (A - mean(A, "all")).*(B - mean(B, "all"));
    num = sum(num, "all");
    denom = sqrt(sum((A - mean(A, "all")).^2, "all")*sum((B - mean(B, "all")).^2, "all"));
    corr = num / denom;
end 