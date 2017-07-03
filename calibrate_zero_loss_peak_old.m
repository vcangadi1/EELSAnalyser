function varargout = calibrate_zero_loss_peak(varargin)

% The largest peak of the low-loss spectrum is considered as the ZLP.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%         EELS        - EELS structure
% Output: 
%         EELS        - calibrated energy-loss axis that has 0eV at ZLP
%                       ouput stored at EELS.calibrated_energy_loss_axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%         e_loss      - axis that need to be calibrated to zero-loss peak
%         ll_spectrum - Low loss spectrum
% Output: 
%   calibrated_e_loss - calibrated energy-loss axis that has 0eV at ZLP
%         ll_spectrum - (Optional) low loss spectrum

%% Check if the input is EELS structure and calibrate each pixel


%t1 = tic;
if nargin < 2
    EELS = varargin{1};
    if isstruct(EELS)
        if iscolumn(EELS.energy_loss_axis)
            e_loss = EELS.energy_loss_axis;
        else
            e_loss = EELS.energy_loss_axis';
        end
        E(1,1,1:length(e_loss)) = e_loss;
        calibrated_energy_loss_axis = repmat(E,EELS.SI_x,EELS.SI_y);
        
        [~,idx] = max(permute(EELS.SImage,[3 1 2]));
        idx = squeeze(idx);
        
        calibrated_energy_loss_axis = calibrated_energy_loss_axis - repmat(e_loss(idx),1,1,EELS.SI_z);
        EELS.calibrated_energy_loss_axis = calibrated_energy_loss_axis;
        varargout{1} = EELS;
    else
        error('Invalid input');
    end
else
    e_loss = varargin{1};
    ll_spectrum = varargin{2};
    if isrow(e_loss)
        e_loss = e_loss';
    end
    if isrow(ll_spectrum)
        ll_spectrum = ll_spectrum';
    end
    
    [~,idx] = max(ll_spectrum);
    calibrated_e_loss = e_loss-e_loss(idx);
    
    if nargout<2
        varargout{1} = calibrated_e_loss;
    else
        varargout{1} = calibrated_e_loss;
        varargout{2} = ll_spectrum;
    end
end