%% spks are the times for spike inputs from another spike
function voltages = ik_neuron(I, time, a, b, c, d, spks)

    % v=-65*ones(Ne+Ni,1); % Initial values of v
    v = -65;
    g_syn = 0;
    tau_syn = 20;
    E_syn = 10;
    I_syn = 0;
    
    voltages = zeros(floor(time), 1);
    voltages(1) = v;
    u=b*v; % Initial values of u
    for t=1:floor(time) % simulation of 1000 ms
        if ~isempty(spks) && spks(t) == 1
            g_syn = 1;
        end
        
        I_syn = g_syn*(v - E_syn);
        g_syn = g_syn - (1/1)*g_syn;
        % disp(g_syn);
        
        if v >= 30
            v=c;
            u=u+d;
        end
        v=v+(0.04*v^2+5*v+140-u+I-I_syn);
        u=u+a*(b*v-u);
        voltages(t+1) = v;
    end    
end