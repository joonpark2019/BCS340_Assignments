
clear; clf; hold on;

% Example data
t = [0.1 0.2 0.3 0.4 0.5 0.6];  % Time array
spikes = [0 0 0 1 0 0];         % Spike data
start_time = 0.2;              % Start time of the interval
stop_time = 0.5;               % Stop time of the interval

% Plot the spikes
%stem(t, spikes, 'r', 'Marker', 'none');  % 'r' for red color, 'Marker', 'none' to remove markers
plot(t, spikes);
hold on;

% Use stem to indicate start and stop times
stem([start_time start_time], [-0.1 1.1], 'b', 'Marker', 'none'); % Start time
stem([stop_time stop_time], [-0.1 1.1], 'g', 'Marker', 'none');   % Stop time

% Set axis limits and labels
xlim([min(t) max(t)]);
ylim([-0.1 1.1]);
xlabel('Time');
ylabel('Spikes');

% Add legends
legend('Spikes', 'Start Time', 'Stop Time');

% Hold off to end the current plot
hold off;