function Ep = plasmon_peak(energy_loss_axis, low_loss_spectrum, optional_zlp_logical)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       low_loss_spectrum - Zero-loss and plasmon peaks (low loss spectrum)
%        energy_loss_axis - low loss energy-loss axis
%
% Output:
%            plasmon_peak - Plasmon peak value in $eV$.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check the number of input arguements
if nargin < 3
    optional_zlp_logical = 1;
end
if optional_zlp_logical == 1
    % Calibrate zero-loss peak
    [l,S] = calibrate_zero_loss_peak(energy_loss_axis,low_loss_spectrum);
elseif optional_zlp_logical == 0
    l = energy_loss_axis;
    S = low_loss_spectrum;
end

%% Find peak location plasmon

%%
[~,locs] = findpeaks(S,l,'SortStr','descend','MinPeakDistance',10);

%% Check for the plasmon presence
if length(locs) < 2
    Ep = 0;
elseif optional_zlp_logical == 1
    if locs(2)<locs(1) || locs(2) > 40
        Ep = 0;
    else
        Ep = locs(2);
    end
elseif optional_zlp_logical == 0
    if locs(1) < 5 || locs(1) > 40
        Ep = 0;
    else
        Ep = locs(1);
    end
else
    Ep = 0;
end
