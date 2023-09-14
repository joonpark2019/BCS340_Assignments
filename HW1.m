%Initialize script:
clear; clf; hold on;

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
E_thresh = -55; %threshold voltage for spikes
global E_spike
E_spike = 10;


%% Running The Function:

[t_rec, s_rec, v_m] = spike_generator(-1.2, 1000);

raster(s_rec);

%% Raster plot function:

function raster(t_rec, s_rec)
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


%% Multiple spike generation trials for average firing rate:

function avg_fire_rate = response_func(I_inj)
    %set interval on which to measure 
    time_interval = 100;
    for i=1:100
        [t_rec, s_rec, v_m] = spike_generator(I_inj, time_interval);
    end
    avg_fire_rate = sum(s_rec) / time_interval;
end


%% Spike Generator Function

%input: time interval length (time_len) and I_inj (constant)
%output: arrays of length time_len t(for time) and s_rec(for recorded
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
