clear; clf; hold on;
dt=0.2; tend=5;

dt=0.1; % integration time step [ms]
tau=10; % time constant [ms]
E_L=-65; % resting potential [mV]
theta=-55; % firing threshold [mV]
RI_ext=12; % constant external input [mA Ohm]

period = 20;
  
t_plot = 0:dt:100;
v_rec = zeros(1, size(t_plot,2));
t_rec = zeros(1, size(t_plot,2));
s_rec = zeros(1, size(t_plot,2));
RI_rec =zeros(1, size(t_plot,2)); 

t_step=0; v=E_L;
rect = 0;

% create a rect train
for t=0:dt:100 %ms : create a spike input
    t_step=t_step+1;
    s=v>theta;

    if (mod(t_step, period) == 0)
        
        if (rect == 0)
            rect = 1;
            RI_ext = 20;
        else
            rect = 0;
            RI_ext = 0;
        end
        
    end

    v=s*E_L+(1-s)*(v-dt/tau*((v-E_L)-RI_ext));
    RI_rec(t_step) = RI_ext;
    v_rec(t_step)=v;
    t_rec(t_step)=t;
    s_rec(t_step)=s;
end

subplot(3,1,1);
plot(t_plot, RI_rec)
subplot(3,1,2);
plot(t_plot, v_rec)
subplot(3,1,3);
plot(t_plot, s_rec)
