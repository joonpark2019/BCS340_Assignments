dt=0.1; % integration time step [ms]
tau=10; % time constant [ms]
E_L=-65; % resting potential [mV]
theta=-55; % firing threshold [mV]
RI_ext=12; % constant external input [mA Ohm]
E_spk = 10; % max voltage of action potential 
%% Integration with Euler method
t_step=0; v=E_L;
for t=0:dt:100;
    t_step=t_step+1;
    if v>theta
        v_rec(t_step-1) = E_spk;
        v = E_L;
        s_rec(t_step)=1;
    else
        v = (v-dt/tau*((v-E_L)-RI_ext));
        s_rec(t_step)=0;
    end
    v_rec(t_step)=v;
    t_rec(t_step)=t;
end

plot(t_rec, v_rec)