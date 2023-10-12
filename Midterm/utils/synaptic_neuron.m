
% input: 
% 1. n_trials: number of trials to run simulation
% 2. i_inj: injected current from patch clamp (mA)
% 3. i_noise: noise current factor (mA) to multiply the colored noise by
% 4. spk_input: times of input spikes (mS) - ex. [200 300]: spks at 200ms,
% 300ms
% 5. time_len: time to run neuron simulation (ms)
% 6. plot_flag: flag for plotting membrane potential (0: no plot, 1: plot)
% output: 
% 1. spike train: an array of logical indices indicating spike vs. no spike
% (ex. [0 0 0 1 0 0 0] output is a spike train at 
function spk_output = synaptic_neuron(n_trials, i_inj, i_noise, spk_input, time_len, plot_flag)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike
    global E_syn
    global tau_syn

    %random reset and threshold were ignored in this case: stochasticity
    %comes purely from noise current
    sig_th_rand = 0;
    sig_el_rand = 0;

    %initialize all parameters
    g_syn(:, 1)= zeros(n_trials, 1); i_syn(:, 1)= zeros(n_trials, 1); 
    v_m(:, 1)=zeros(n_trials, 1); t(1)=0;

    E_L = E_rest + randn(n_trials,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;

        %check for spike input
        if min(abs(t(i) - spk_input)) < 0.001 
            g_syn(:, i-1) = 1;
        end

        g_syn(:, i)= g_syn(:, i-1) - dt/tau_syn * g_syn(:, i-1);
        i_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        
        %update using Euler's method
        v_m(:, i) = v_m(:, i-1) - dt.*(1/tau) * (v_m(:, i-1) - E_rest) ...
        + dt*(R/tau).* i_inj ...
        + dt*(R/tau) .* colored_noise(n_trials,1,-1)*i_noise ...
        - dt*(R/tau)* i_syn(:, i);
        
        %check for spikes using Euler's method
        spks = v_m(:, i) > (E_thresh + randn(1)*sig_th_rand);
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
    end

    %plot membrane potential v_m based on plot flag
    if plot_flag
        figure('Position', [50, 50, 1000, 900]);
        subplot(n_trials,1,1);
        plot(t(:), v_m(1,:))
        title("Membrane Potential")
        xlabel('Time (ms)', 'FontSize', 10);
        ylabel('Voltage (mV)', 'FontSize', 10);
        for i=2:n_trials
            subplot(n_trials,1,i);
            plot(t(:), v_m(i,:))
            title("Membrane Potential")
            xlabel('Time (ms)', 'FontSize', 10);
            ylabel('Voltage (mV)', 'FontSize', 10);
        end

    end
 
    % spike output is an array of logical indices indicating whether a
    % spike occurs at a certain time
    spk_output = v_m == E_spike;
    

end
