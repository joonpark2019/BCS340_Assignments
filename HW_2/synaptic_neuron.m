
%this is a function for neuron with stochastic reset and stochastic
%threshold
% input: spike train
% output: spike train
function spk_output = synaptic_neuron(N, I_inj, spk_input, time_len, Inoise)%Inoise is zero if no noise considered
    global E_rest
    global tau
    global dt
    global R
    global E_thresh
    global E_spike
    global E_syn
    global tau_syn

    sig_th_rand = 0.55;
    sig_el_rand = 0.65;
    sig_conductance = 0.1;
    %sig_I_rand = 10;

    g_syn(:, 1)= zeros(N, 1); I_syn(:, 1)= zeros(N, 1); 
    v_m(:, 1)=zeros(N, 1); t(1)=0;

    E_L = E_rest + randn(N,1)*sig_el_rand;

    for i= 2:time_len/dt
        t(i)=t(i-1)+dt;

        if min(abs(t(i) - spk_input)) < 0.001 
            g_syn(:, i-1) = 1;
        end

        g_syn(:, i)= g_syn(:, i-1) - dt/tau_syn * g_syn(:, i-1);
        I_syn(:, i)= g_syn(:, i).*(v_m(:, i-1)-E_syn);
        v_m(:, i) = v_m(:, i-1) - dt*(1/tau) * (v_m(:, i-1) - E_rest) ...
        + dt*(R/tau)* I_inj ...
        + dt*(R/tau) * rand(N,1)*Inoise ...
        - dt*(R/tau)* I_syn(:, i);

        spks = v_m(:, i) > (E_thresh + randn(1)*sig_th_rand);
        v_m(spks == 1, i-1) = E_spike;
        v_m(spks == 1, i) = E_L(spks == 1);
        
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
