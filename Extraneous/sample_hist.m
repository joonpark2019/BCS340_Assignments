clear all, clc, close all

% X = [2 2 3 4 4 5 6 7 7 7 7 8 9 10 11];
% disp(X);
% edges = 2:2:10;
% indx = zeros(1,length(X));
% indx(edges) = 1;
% disp(indx);
% Y = discretize(X,edges);
% disp(Y);

% bins = 0:10:100;
% x = [51,42,43,56,76,54,34,56,78,80];
% newx = bins(discretize(x,bins));
% disp(newx);
% 
global dt
dt = 0.1;
%

% Define two spike trains (as arrays of spike times)
spike_train1 = [0.5, 1.2, 2.0, 3.1, 3.6, 4.7, 5.5];
spike_train2 = [0.7, 1.0, 2.2, 3.3, 3.8, 4.9, 5.3];

% Set the time window and bin size for the histogram
time_window = 1.0;  % Time window in seconds
bin_size = 0.1;     % Bin size in seconds

% Initialize an array to store spike time differences
spike_time_differences = [];

% Calculate spike time differences within the time window
for t1 = spike_train1
    for t2 = spike_train2
        time_diff = abs(t1 - t2);
        if time_diff <= time_window
            spike_time_differences = [spike_time_differences, time_diff];
        end
    end
end

% Create a histogram of spike time differences
histEdges = 0:bin_size:time_window;
histCounts = histcounts(spike_time_differences, histEdges);
