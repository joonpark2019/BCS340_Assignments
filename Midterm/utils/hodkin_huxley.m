function v_m = hodkin_huxley(i_inj, time)


    %% Integration of Hodgkin--Huxley equations with Euler method
    %% Setting parameters
    % Maximal conductances(in units of mS/cm^2); 1=K, 2=Na, 3=R
    g(1)=36; g(2)=120; g(3)=0.3;
    % Battery voltage ( in mV); 1=n, 2=m, 3=h
    E(1)=-12; E(2)=115; E(3)=10.613;
    % Initialization of some variables
     V=-10; x=zeros(1,3);  t_rec=0; %x(3)=1;
    % Time step for integration
    dt=0.01;
    v_m = zeros(floor(time/dt), 1);
    R = 10; %resistance(Ohms)

    %% Integration with Euler method
    for i= 1:floor(time/dt)
        
        % alpha functions used by Hodgkin-and Huxley
        Alpha(1)=(10-V)/(100*(exp((10-V)/10)-1));
        Alpha(2)=(25-V)/(10*(exp((25-V)/10)-1));
        Alpha(3)=0.07*exp(-V/20);
        % beta functions used by Hodgkin-and Huxley
        Beta(1)=0.125*exp(-V/80);
        Beta(2)=4*exp(-V/18);
        Beta(3)=1/(exp((30-V)/10)+1);
        % tau_xand x_0 (x=1,2,3) are defined
        tau=1./(Alpha+Beta);
        x_0=Alpha.*tau;
        % leaky integration with Euler method
        x=(1-dt./tau).*x+dt./tau.*x_0;

        % calculate actual conductances with given n, m, h
        gnmh(1)=g(1)*x(1)^4;
        gnmh(2)=g(2)*x(2)^3*x(3);
        gnmh(3)=g(3);
        % Ohm's law
        I=gnmh.*(V-E);
        % update voltage of membrane
        V=V+dt*(i_inj(i)-sum(I));
        v_m(i) = V;
    end
end% time loop