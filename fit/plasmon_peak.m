function Ep = plasmon_peak(energy_loss_axis, low_loss_spectrum)
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%       low_loss_spectrum - Zero-loss and plasmon peaks (low loss spectrum)
%        energy_loss_axis - low loss energy-loss axis
%            
% Output: 
%            plasmon_peak - Plasmon peak value in $eV$.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calibrate zero-loss peak

%%
[l,S] = calibrate_zero_loss_peak(energy_loss_axis,low_loss_spectrum);

%% Find peak location plasmon

%%
[~,locs] = findpeaks(S,l,'SortStr','descend','MinPeakDistance',10);

%% Check for the plasmon presence

%%
if length(locs)<2
    Ep = 0;
elseif locs(2)<locs(1) || locs(2) > 40
    Ep = 0;
else
    Ep = locs(2);
end
