clear; close all; 

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




[t_rec, v_m] = spike_generator_standard(10, -1.1, 1000, 0);

s = v_m == E_spike;
% Create a raster plot
[rowIndices, timeIndices] = find(s);

% Plot spikes as dots on a grid
figure;
scatter(timeIndices, rowIndices, 10, 'k', 'filled');  % Adjust 'k' for color and 'filled' for filled markers

% Set plot properties
xlabel('Time');
ylabel('Neuron');
title('Raster Plot');
ylim([0.5, size(s, 1) + 0.5]);  % Set the y-axis limits to match the number of rows
grid on;

% Optionally, invert the y-axis to display the top row at the top
set(gca, 'YDir', 'reverse');





%% Spike Generator Function

%this is a function for neuron with stochastic reset and stochastic
%conductance
%no synapses are considered in modelling
%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t, v_m] = spike_generator_standard(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    E_syn=-40;

    %sig_th_rand = 0.01;
    sig_el_rand = 5;
    sig_conductance = 0.01;
    %sig_I_rand = 10;

    g_syn(:, 1)= zeros(N, 1); I_syn(:, 1)= zeros(N, 1); 
    v_m(:, 1)=zeros(N, 1); t(1)=0;

    E_L = E_rest + randn(N,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;
        
        %Don't consider any synapses from another cell (consider cell in
        %isolation)
        %Make the 

        %g_syn(:, i)= g_syn(:, i-1) - dt/tau * g_syn(:, i-1);
        %I_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) *(v_m(:, i-1) - E_rest) ...
        - dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;
        %- dt*(R/tau)* I_syn(:, i) ...

        %problem here with vectorization:
        spks = v_m(:, i) > E_thresh;
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_rest; %no random reset for standard leaky if
        
    end

end



%this is a function for neuron with stochastic reset and stochastic
%conductance
%no synapses are considered in modelling
%input: time interval [ms] and I_inj [ms]
%output: arrays of length time_len t(for time in ms) and s_rec(for recorded
%spikes)
function [t, v_m] = spike_generator_stochastic(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike

    E_syn=-40;

    %sig_th_rand = 0.01;
    sig_el_rand = 5;
    sig_conductance = 0.01;
    %sig_I_rand = 10;

    g_syn(:, 1)= zeros(N, 1); I_syn(:, 1)= zeros(N, 1); 
    v_m(:, 1)=zeros(N, 1); t(1)=0;

    E_L = E_rest + randn(N,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;
        
        %Don't consider any synapses from another cell (consider cell in
        %isolation)
        %Make the 

        %g_syn(:, i)= g_syn(:, i-1) - dt/tau * g_syn(:, i-1);
        %I_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) *(1 + sig_conductance * randn(N, 1)).* (v_m(:, i-1) - E_rest) ...
        - dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;
        %- dt*(R/tau)* I_syn(:, i) ...

        %problem here with vectorization:
        spks = v_m(:, i) > E_thresh;
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
    end

end
