
function poiss_dist = poisson_analytic(avg_N, n)
    poiss_dist = (avg_N.^n.*exp(1).^(-1*avg_N))./factorial(n);
end
