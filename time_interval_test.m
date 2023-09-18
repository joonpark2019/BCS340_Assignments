%Initialize script:
clear; close all; clf;


%% Todo:
% 1. plot multiple raster plots using different colors


%% Setting some constants and initial values

%setting as global variables to be used in the spike generator
global E_rest
E_rest = -65; % resting potential [mV]
global tau
tau = 20; % time constant [ms]
global dt
dt=0.1; % integration time step [ms]
global R
R = 10; %resistance(Ohms)
global E_thresh
E_thresh = -55; %threshold voltage for spikes [mV]
global E_spike %[mV]
E_spike = 10;


%% Running Experiment to Find Appropriate Measurement Time Interval :
%assumption: there is a time interval for which start time is not too
%relevant (good enough)

I_init = -1.0000000000000711652959; %approximate current at which spiking starts
trials = 1;
test_time_interval = 10000; %[ms] --> 10 sec
measure_time_int = 5000;    %[ms] --> 0.1 sec

[t_rec, s_rec, v_m] = spike_generator(I_init, test_time_interval);
measure_interval = floor(measure_time_int / dt);
spk_indices = find(s_rec); %find the first non-zero spike in series (ex. [0 0 1 0 0] --> 3)
        
min_spk_interval = 0;
if (size(spk_indices) <= 1)
    disp("No spikes or only one spike!!");
    return;
else
    min_spk_interval = spk_indices(2) - spk_indices(1);
end
    %disp(spk_indices)

disp("min spike interval"); disp(min_spk_interval);

           %random starting time: offset by a fraction of the interval
           %between two consecutive spikes
start_ind = min(spk_indices) + abs(floor(min_spk_interval* randn)); %measure interval must be greater than
end_ind = start_ind + measure_interval;
        
spk_interval = s_rec(start_ind:end_ind); 
delta_t = t_rec(end_ind) - t_rec(start_ind); %[ms]
        %disp(meas_interval);
fire_rate_1 = sum(spk_interval) * 1000 / delta_t;
fire_rate_2 = 1000 / (min_spk_interval * dt);

disp("Fire rate from spikes in interval: "); disp(fire_rate_1);
disp("Fire rate from 2 consecutive spikes: "); disp(fire_rate_2);

start_time = start_ind * dt;
stop_time = end_ind * dt;

stem(t_rec, s_rec, 'r', 'Marker', 'none'); hold on;
stem([start_time start_time], [-0.1 1.1], 'b', 'Marker', 'none'); % Start time
stem([stop_time stop_time], [-0.1 1.1], 'g', 'Marker', 'none');   % Stop time

xlabel('Time');
ylabel('Spikes');
% Add legends
legend('Spikes', 'Start Time', 'Stop Time');

% Hold off to end the current plot
hold off;
% 
% 
% [s_rec, f_rate1, f_rate2, s_ind, e_ind] = single_fire_rate(I_init, test_time_interval, measure_time_int);
% disp("Fire rate from spikes in interval: "); disp(f_rate1);
% disp("Fire rate from 2 consecutive spikes: "); disp(f_rate2);
% start_time = s_ind * dt;
% stop_time = e_ind * dt;
% disp("start time: "); disp(start_time);
% disp("stop time: "); disp(stop_time);
% 
% t = linspace(0, test_time_interval, size(s_rec, 1));
% stem(t, s_rec, 'r', 'Marker', 'none'); hold on;
% stem([start_time start_time], [-0.1 1.1], 'b', 'Marker', 'none'); % Start time
% stem([stop_time stop_time], [-0.1 1.1], 'g', 'Marker', 'none');   % Stop time
% 
% % Set axis limits and labels
% 
% xlabel('Time');
% ylabel('Spikes');
% % Add legends
% legend('Spikes', 'Start Time', 'Stop Time');
% 
% % Hold off to end the current plot
% hold off;


%% Raster plot function:
% http://www.mit.edu/people/abbe/matlab/handle.html
% https://labrigger.com/blog/2011/12/05/raster-plots-and-matlab/
function raster(in)
    if size(in,1) > size(in,2)
        in=in';
    end
    axis([0 max(in)+1 -1 2])
    plot([in;in],[ones(size(in));zeros(size(in))],'k-')
    set(gca,'TickDir','out') % draw the tick marks on the outside
    set(gca,'YTick', []) % don't draw y-axis ticks
    set(gca,'PlotBoxAspectRatio',[1 0.05 1]) % short and wide
    set(gca,'Color',get(gcf,'Color')) % match figure background
    set(gca,'YColor',get(gcf,'Color')) % hide the y axis
    box off
end

%% Stable Fire Rate Experiment:

%has a stochastic start time for measuring fire rate
%received measurement time interval AND num_trials to run as an input
%outputs an array of length num_trials --> can find range of fire rates -->
%find a sufficient time_interval to minimize range by tuning
% NOTE: make the time_interval incredibly long to accomodate as many spikes
% as possible



function [fire_rates, s_inds, e_inds] = fire_rate_measure(I_inj, num_trials, time_interval, measure_time)
    global dt
    fire_rates = zeros(num_trials);
    s_inds =  zeros(num_trials);
    e_inds =  zeros(num_trials);

    figure;

    for i=1:num_trials
        [s_rec, f_rate, s_ind, e_ind] = single_fire_rate(I_inj, time_interval, measure_time);
        fire_rates(i) = f_rate;
        s_inds(i) = s_ind;
        e_inds(i) = e_ind;

        subplot(num_trials, 1, i);
        t = linspace(0, floor(time_interval/dt), size(s_rec, 1));

        start_time = s_ind * dt;

        stop_time = e_ind * dt;
  
        plot(t, s_rec);
        stem([start_time start_time], [-0.1 1.1], 'b', 'Marker', 'none'); % Start time
        stem([stop_time stop_time], [-0.1 1.1], 'g', 'Marker', 'none');   % Stop time

        title(['Plot ' num2str(i)]);

    end
end


function [s_rec, fire_rate_1, fire_rate_2, start_ind, end_ind] = single_fire_rate(I_inj, time_interval, measure_time)

    global dt

    [t_rec, s_rec, v_m] = spike_generator(I_inj, time_interval);
    
    %indices for sampling spikes
    measure_interval = floor(measure_time / dt);
    spk_indices = find(s_rec); %find the first non-zero spike in series (ex. [0 0 1 0 0] --> 3)
        
    min_spk_interval = 0;
    if (size(spk_indices) <= 1)
        disp("No spikes or only one spike!!");
        return;
    else
        min_spk_interval = spk_indices(2) - spk_indices(1);
    end
    %disp(spk_indices)

    disp("min spike interval"); disp(min_spk_interval);

           %random starting time: offset by a fraction of the interval
           %between two consecutive spikes
    start_ind = min(spk_indices) + abs(floor(min_spk_interval* randn)); %measure interval must be greater than
    end_ind = start_ind + measure_interval;
        
    spk_interval = s_rec(start_ind:end_ind); 
    delta_t = t_rec(end_ind) - t_rec(start_ind); %[ms]
        %disp(meas_interval);
    fire_rate_1 = sum(spk_interval) * 1000 / delta_t;
    fire_rate_2 = 1 / (min_spk_interval * dt);

end


%% Spike Generator Function

%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t_rec, s_rec, v_m] = spike_generator(I_inj, time_len)
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    t_step=0; v=E_rest;
    for t=0:dt:time_len
        t_step=t_step+1;
        if v>E_thresh
            v_m(t_step-1) = E_spike;
            v = E_rest;
            s_rec(t_step)=1;
        else
            v = (v-dt/tau*((v-E_rest)+R*I_inj));
            s_rec(t_step)=0;
        end
        v_m(t_step)=v;
        t_rec(t_step)=t;
    end
end
