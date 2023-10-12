

%no synapses are considered in modelling
%input: 
% --> N: number of trials i.e. number of spike trains to generate
% simultaneously
% --> time_len: time interval over which spikes are generated [ms]
% --> I_inj : input current [ms]
% --> Inoise : noise current input [mA], noise is samples from a uniform
% distribution in [-I_noise, I_noise]

%output: 
% --> t: array of length time_len(time in ms)/dt which records times in increments of dt
% --> v_m: array of same length as t which records membrane voltage for each time increment 
function spk_output = spike_generator_stochastic(N, I_inj, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike


    %standard deviations for random threshold, reset, and conductance
    sig_th_rand = 0; % std_dev for random threshold voltage [mV]
    sig_el_rand = 0; % std_dev for random reset voltage [mV]

    g_syn(:, 1)= zeros(N, 1); I_syn(:, 1)= zeros(N, 1); 
    v_m(:, 1)=zeros(N, 1); t(1)=0;

    E_L = E_rest + randn(N,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;
        
        %Use Euler's method:
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) * (v_m(:, i-1) - E_rest) ...
        + dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise;

        %Check if voltage is greater than the threshold voltage
        spks = v_m(:, i) > (E_thresh + randn(1)*sig_th_rand);
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
        %check for spikes using Euler's method
        spks = v_m(:, i) > (E_thresh + randn(1)*sig_th_rand);
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);

    end

    spk_output = v_m == E_spike;

end
