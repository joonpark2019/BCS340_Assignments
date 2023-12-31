% Creates a Poisson spike train with spike count equal to num_spks
%input: fr_mean (firing rates in num_spikes / miliseconds.  
% ex) 500/1000 --> 500 spikes in 1000 ms, or 50 Hz
% time: length of spike train in ms
%output: times for spikes in ms ex) [0 50 100 .....]
function [spk_times, spk_output] = poisson_spk_train_isi(n_trials, fr_mean, time)
    global dt;
    %num_spks = floor(fr_mean * time);
    isi = -(1/fr_mean).*log(rand(n_trials, floor(time/dt)));
    % disp("size(isi)");
    % disp(size(isi));
    spk_times = cumsum(isi, 2);
    % disp("mean:");
    % disp(mean(transpose(spk_times)));
    % disp("%%%%%%%%%%%%");
    % disp(min(transpose(spk_times)));
    % disp(size(spk_times));
    spk_times = spk_times.*(spk_times < time);
    spk_indices = floor(spk_times / dt);
    % disp(size(spk_times));
    spk_output = zeros(n_trials, floor(time/dt));
    % spk_output(floor(spk_times / dt) > 0) = 1;

    for ii=1:n_trials
        ind = 1:find(spk_indices(ii, :), 1, 'last');
        spk_output(ii, spk_indices(ii, ind)) = 1;
    end
end

% outputs spike times or spks with spike indices??