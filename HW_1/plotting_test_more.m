clear; clf; hold on;

[X, Y] = meshgrid(linspace(0, 10, 10), linspace(0, 10, 10));
data = randn(size(X));
plot(X, data);