
%this is a function for neuron with stochastic reset and stochastic
%threshold
% input: spike train
% output: spike train
function spk_output = synaptic_neuron(n_trials, i_inj, i_noise, spk_input, time_len, plot_flag)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike
    global E_syn
    global tau_syn

    % sig_th_rand = 0.55;
    % sig_el_rand = 0.65;

    sig_th_rand = 0;
    sig_el_rand = 0;

    g_syn(:, 1)= zeros(n_trials, 1); i_syn(:, 1)= zeros(n_trials, 1); 
    v_m(:, 1)=zeros(n_trials, 1); t(1)=0;

    E_L = E_rest + randn(n_trials,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;

        if min(abs(t(i) - spk_input)) < 0.001 
            g_syn(:, i-1) = 1;
        end

        g_syn(:, i)= g_syn(:, i-1) - dt/tau_syn * g_syn(:, i-1);
        i_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        
        %disp(size(i_inj));
        v_m(:, i) = v_m(:, i-1) - dt.*(1/tau) * (v_m(:, i-1) - E_rest) ...
        + dt*(R/tau).* i_inj ...
        + dt*(R/tau) .* colored_noise(n_trials,1,-1)*i_noise ...
        - dt*(R/tau)* i_syn(:, i);
        
        

        spks = v_m(:, i) > (E_thresh + randn(1)*sig_th_rand);
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
    end

    
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
    %figure;
    %subplot(3,1,1);
    %plot(t(:), v_m(1,:))
    % title("V_m")
    % xlabel('Time (ms)', 'FontSize', 10);
    % ylabel('Voltage (mV)', 'FontSize', 10);
    %subplot(3,2,1);
    %plot(t(:), g_syn(1,:))
    % title("g_syn");
    % xlabel('Time (ms)', 'FontSize', 10);
    % ylabel('Conductance (Siemens)', 'FontSize', 10);
    %subplot(3,3,1);
    %plot(t(:), I_syn(3, :))
    % title("I_syn");
    % xlabel('Time (ms)', 'FontSize', 10);
    % ylabel('Synaptic Current (mA)', 'FontSize', 10);

    spk_output = v_m == E_spike;
    

end
