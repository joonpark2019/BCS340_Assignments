%Initialize script:
clear; clf; hold on;


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

I_init = -1.2; %approximate current at which spiking starts
trials = 10;
measure_time_int = 100;
fire_rates = experiment1(I_init, trials, 1000, measure_time_int);
avg_fire_rate = mean(fire_rates);
range_fire_rate = max(fire_rates) - min(fire_rates);
disp("Average fire rate: ");
disp(avg_fire_rate);
disp("Range of fire rates: ");
disp(range_fire_rate);

%I_init = -1.50; %approximate current at which spiking starts
%measure_time_int = 100;
%fire_rates = experiment1(I_init, 10, 10000, measure_time_int);
%avg_fire_rate = mean(fire_rates);
%range_fire_rate = max(fire_rates) - min(fire_rates);
%disp("Average fire rate: ");
%disp(avg_fire_rate);
%disp("Range of fire rates: ");
%disp(range_fire_rate);

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
function fire_rates = experiment1(I_inj, num_trials, time_interval, measure_time)

    global dt

    for i=1:num_trials
         
        [t_rec, s_rec, v_m] = spike_generator(I_inj, time_interval);

        plot(t_rec, s_rec);
        
        measure_interval = floor(measure_time / dt);
        
        spk_indices = find(s_rec);
        times = t_rec(spk_indices);
        
        min_spk_interval = 0;
        if (size(spk_indices) <= 1)
            disp("No spikes or only one spike!!");
            return;
        else
            min_spk_interval = spk_indices(2) - spk_indices(1);
        end

           %random starting time: offset by a fraction of the interval
           %between two consecutive spikes
        start_ind = min(spk_indices) + abs(floor(min_spk_interval* randn)); %measure interval must be greater than
        
        spk_interval = s_rec(start_ind:(start_ind + measure_interval )); 
        delta_t = t_rec(start_ind + measure_interval) - t_rec(start_ind); %[ms]
        %disp(meas_interval);
        fire_rates(i) = sum(spk_interval) * 1000 / delta_t;
    end
end


%% Spike Generator Function

%input: time interval length (time_len) and I_inj (constant)
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
    for t=0:dt:floor(time_len/dt)
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
