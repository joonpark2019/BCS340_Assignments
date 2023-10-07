% Creates a Poisson spike train with spike count equal to num_spks
% input: fr_mean (mean firing rate), num_spks (number of spikes to
% generate)
%output: spike train

%units of fr_mean = Hz (50/1000 --> 50 spikes every 1000 ms --> 50 Hz??)
function spk_output = poisson_spk_train(fr_mean, time)
    global dt;
    num_spks = floor(fr_mean * time);
    isi = -(1/fr_mean).*log(rand(num_spks,1));
    spk_times = cumsum(isi);
    
    % spk_times(spk_times > time)=0; %remove all entries beyond the maximum time duration
    % spk_times = find(spk_times);

    %convert times in ms to indices
    % spk_output = floor(spk_times / dt);
    spk_output = spk_times;

    % spk_output = zeros(1, length(spks));
    % spk_output(spks) = 1;
    % spk_output = spk_output(1:floor(time/dt));

end