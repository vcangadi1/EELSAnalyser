function wp = plasmon_width(energy_loss_axis, low_loss_spectrum)
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%        energy_loss_axis - energy loss axis
%       low_loss_spectrum - Zero-loss peak (low loss spectrum)
%            
% Output: 
%                 wp - Plasmon width value in eV.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find locations of zero-loss peak and plasmon peak

Z = low_loss_spectrum;
l = energy_loss_axis;

[~,locs] = findpeaks(Z,'SortStr','descend','MinPeakDistance',round(10/(l(2)-l(1))));

if length(locs) < 2
    wp = 0;
elseif locs(2) < locs(1)
    wp = 0;
elseif l(locs(2)) < 50
    [~,min_idx] = min(Z(locs(1):locs(2)));
    min_idx = locs(1) + min_idx - 1;
    wp = fwhm(l(min_idx:end),Z(min_idx:end));
else
    wp = 0;
end

%% Find wp with Lorentzian fit to plasmon

