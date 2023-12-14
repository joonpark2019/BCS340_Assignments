function g = gaussian(mu, sigma, N)

    x = 1:1:N;
    g = (1/(sqrt(2*pi)*sigma)).* exp(-1*(((x)-mu).^2)/ (2*sigma^2));
end