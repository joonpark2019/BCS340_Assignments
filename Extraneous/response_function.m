
%% revised calculation for rate with gaussian:
function corr = response_function(spk_input, spk_output)
    global E_spike
    global dt

    assert(length(spk_input) == length(spk_output));

    %% create a gaussian kernel:
    sigma = 5;

    
    % binsize = 5 * dt; % in seconds, so everything else should be seconds too
    % gauss_window = 1./binsize; % 1 ms window
    % gauss_SD = 1./binsize; % 0.02 seconds (20ms) SD
    % gk = gausskernel(gauss_window,gauss_SD); gk = gk./binsize; % normalize by binsize


    % window_len = 500/dt;
    % width_factor = (window_len - 1) / (2 * sigma);
    % gk = gausswin(window_len, width_factor); %gk = gk * 1/(sqrt(2*pi)*sigma);


    gaussian_range = -3*sigma:3*sigma; % setting up Gaussian window
    gaussian_kernel = normpdf(gaussian_range,0,sigma); % setting up Gaussian kernel
    gaussian_kernel = gaussian_kernel * (sqrt(2*pi)*sigma);

    t_win = 1:length(gaussian_kernel); t_win = dt * t_win;
    t = 1:length(spk_input); t = dt * t;


    %% convolve spike trains with the gaussian filter
    gau_sdf_input = conv2(spk_input,gaussian_kernel,'same');
    gau_sdf_output = conv2(spk_output,gaussian_kernel,'same');

    %% correlation:
    corr = corrcoef(gau_sdf_input, gau_sdf_output);
    %t_corr = 1:length(corr); t_corr = dt * t_corr;

    for i
    

    %% plot all curves
    figure('Position', [50, 50, 1000, 900]);
    subplot(3,1,1);
    plot(t, gau_sdf_input);
    subplot(3,1,2);
    plot(t, gau_sdf_output);
    subplot(3,1,3);
    plot(t_win, gaussian_kernel);
    

    
end
