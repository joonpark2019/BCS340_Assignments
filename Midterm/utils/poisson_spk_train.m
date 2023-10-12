% Creates a Poisson spike train with spike count equal to num_spks
%input: fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% time: length of spike train in ms
%output: times for spikes in ms ex) [0 50 100 .....]
function spk_output = poisson_spk_train(fr_mean, time)
    global dt;
    num_spks = floor(fr_mean * time);
    isi = -(1/fr_mean).*log(rand(num_spks,1));
    spk_output = cumsum(isi);

end