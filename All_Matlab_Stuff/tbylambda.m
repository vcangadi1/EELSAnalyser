function tlambda = tbylambda(energy_loss_axis, low_loss_spectrum)
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%       low_loss_spectrum - Zero-loss peak (low loss spectrum)
%            
% Output: 
%                 tlambda - Thickness $t/\lambda$ value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find locations of zero-loss peak and plasmon peak

Z = low_loss_spectrum;
l = energy_loss_axis;
d = mean(diff(l));

[~,locs] = findpeaks(Z,'SortStr','descend','MinPeakDistance',1/d);

if length(locs) < 2
    tlambda = 0;
elseif locs(2) < locs(1)
    tlambda = 0;
else
    [~,min_idx] = min(Z(locs(1):locs(2)));
    min_idx = locs(1) + min_idx - 1;
    I0 = sum(Z(1:min_idx)); %I0 = trapz(l(1:min_idx),Z(1:min_idx));
    It = sum(Z); %It = trapz(l,Z);
    tlambda = -log(I0/It);
end