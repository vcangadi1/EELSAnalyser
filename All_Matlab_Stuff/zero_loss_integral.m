function I0 = zero_loss_integral(energy_loss_axis,low_loss_spectrum)
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%       low_loss_spectrum - Zero-loss peak (low loss spectrum)
%            
% Output: 
%                 I0 - Zero-loss intergral value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find locations of minimum between zero-loss peak and plasmon peak
Z = low_loss_spectrum;
l = energy_loss_axis;

[~,locs] = findpeaks(Z,'SortStr','descend','MinPeakDistance',4);

if length(locs) < 2
    I0 = 0;
elseif locs(2) < locs(1)
    I0 = 0;
else
    min_idx = find(Z(locs(1):locs(2)) == min(Z(locs(1):locs(2))),1);
    min_idx = locs(1) + min_idx - 1;
    I0 = sum(Z(1:min_idx)); %I0 = trapz(l(1:min_idx),Z(1:min_idx));
end