function [zlp_shift,e_loss_shift] = shift_zlp(Z, e_loss, FilterOption)
%%
% Shift the ZLP to begining of the spectrum (channel 1) for deconvolution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%            Z        - Zero-loss peak (low loss spectrum)
%            e_loss   - axis that need to be calibrated to zero-loss peak
% Output:
%         zlp_shift   - Zero-loss peak (low loss spectrum)
%        e_loss_shift - calibrated energy-loss axis that has 0eV at ZLP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Defaults
if nargin<3
    FilterOption = 'chebwin';
end

%% Convert to column matrix
if isrow(Z)
    Z = Z';
end


%% Window filtering to remove discontinuity in the spectrum
% Filter
if ~strcmpi(FilterOption,'none')
    L = 100;
    fhandle = str2func(FilterOption);
    h = window(fhandle,L*2);
    H = [zeros((length(Z)-L*2)/2,1);h;zeros((length(Z)-L*2)/2,1)];
    
    % Fourier transform the spectrum
    fftZ = fftshift(fft(Z));
    hfftZ = fftZ.*H;
    hZ = abs(ifft(hfftZ));
    Z = [hZ(1:15);Z(16:end-16);hZ(end-15:end)];
end

%% Find index of zlp (peak)
idx_zlp = find(Z==max(Z));

Zn = [Z(idx_zlp:end);Z(1:idx_zlp-1)];
zlp_shift = Zn;

%% Re-calibrate e_loss so that zlp has 0eV

if nargin>1
    if isempty(e_loss)
        e_loss = 1:length(Zn);
    end
    if isrow( e_loss )
        e_loss = e_loss';
    end
    if nargout==2
        e_loss_shift = calibrate_zero_loss_peak(e_loss,Zn);
    end
else
    e_loss_shift = [];
end
