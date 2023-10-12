%input: fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% time: length of spike train in ms
%output: times for spikes in ms ex) [0 50 100 .....]
function spk_output = regular_spk_train(fr_mean, time)
    global dt

    period = floor((1/fr_mean)); %time period between spikes [ms]
    spk_output = period:period:time;

end