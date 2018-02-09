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

%%

if nargin < 1
    error('Not enough input arguments');
end

if isstruct(varargin{1})
    if nargin == 1
        %Opt = 1;
        EELS = calibrate_SI_finding_max(varargin{1});
        varargout{1} = EELS;
    elseif nargin == 2
        if ischar(varargin{2})
            %Opt = 2;
            tic;
            EELS = calibrate_SI_fit(varargin{1});
            toc;
            varargout{1} = EELS;
        else
            error('Hint : 2nd input must be a string/char array. eg: Gaussian');
        end
    end
elseif nargin > 1 && nargin < 4
    if (iscolumn(varargin{1}) || isrow(varargin{1})) && (iscolumn(varargin{2}) || isrow(varargin{2})) && ~(isstruct(varargin{2}) || isstruct(varargin{2}))
        if nargin == 2 && ~ischar(varargin{1}) && ~ischar(varargin{2})
            %Opt = 3;
            [calibrated_e_loss,ll_spectrum] = calibrate_spectrum_finding_max(varargin{1},varargin{2});
            if nargout < 2
                varargout{1} = calibrated_e_loss;
            else
                varargout{1} = calibrated_e_loss;
                varargout{2} = ll_spectrum;
            end
        elseif nargin == 3 && ~ischar(varargin{1}) && ~ischar(varargin{2}) && ischar(varargin{3})
            %Opt = 4;
            if strcmpi(varargin{3},'Gauss') || strcmpi(varargin{3},'gauss1') || strcmpi(varargin{3},'Gaussian')
                [calibrated_e_loss,Z] = calibrate_spectrum_fit(varargin{1},varargin{2});
            else
                error('Hint : Third input must be either of of strings : \n Gaussian, Gauss or gauss1');
            end
            if nargout < 2
                varargout{1} = calibrated_e_loss;
            else
                varargout{1} = calibrated_e_loss;
                varargout{2} = Z;
            end
        else
            error('Invalid inputs');
        end
    else
        error('Invalid inputs');
    end
elseif Opt < 0
    error('Invalid inputs');
end

end

%%
function EELS = calibrate_SI_finding_max(EELS)

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
    EELS.l = @(ii,jj) squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
    EELS.calibration_method = 'Max_peak';
else
    error('In subfunction calibrate_SI_finding_max, EELS input is not a struct type');
end
end

%%
function [calibrated_e_loss,ll_spectrum] = calibrate_spectrum_finding_max(e_loss,ll_spectrum)

if isrow(e_loss)
    e_loss = e_loss';
end
if isrow(ll_spectrum)
    ll_spectrum = ll_spectrum';
end

if isrow(e_loss)
    e_loss = e_loss';
end
if isrow(ll_spectrum)
    ll_spectrum = ll_spectrum';
end

[~,idx] = max(ll_spectrum);
calibrated_e_loss = e_loss-e_loss(idx);

end

%%
function EELS = calibrate_SI_fit(EELS)

% Check for parallel workers
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolobj = parpool;
end

l = EELS.energy_loss_axis;

if ~isfield(EELS,'S')
    EELS.S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));
end

calibrated_l = zeros(size(EELS.SImage));

id = zeros(EELS.SI_x, 1);
s = id;
f = id;

fun = @(ii,jj) calibrate_spectrum_fit(l,EELS.S(ii,jj));

parfor_progress(EELS.SI_x);

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    calibrated_l(ii,:,:) = cell2mat(arrayfun(@(jj) fun(ii,jj), c.Value,'UniformOutput',false)')';
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;

figure;
plotIntervals(s, f, id, min(s)); % plotIntervals

%{
h = waitbar(0,'1','Name','Calibrating zero loss SI...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

S = EELS.S;
c = parallel.pool.Constant(l);
for ii = 1:EELS.SI_x
    % Check for Cancel button press
    if getappdata(h,'canceling')
        break
    end
    % Report current estimate in the waitbar's message field
    waitbar(ii/EELS.SI_x,h,sprintf('Evaluation is at row = %d, Completed = %6.2f%%',ii,ii/EELS.SI_x*100))
    parfor jj = 1:EELS.SI_y
        [calibrated_l(ii,jj,:),~,E0(ii,jj)] = calibrate_spectrum_fit(c.Value,feval(S,ii,jj));
    end
end
delete(h)       % DELETE the waitbar; don't try to CLOSE it.
toc;
%}

% delete parallel pool object
delete(poolobj);


EELS.calibrated_energy_loss_axis = calibrated_l;
EELS.l = @(ii,jj) squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
EELS.calibration_method = 'Gaussian_fit';

end

%%
function [calibrated_e_loss,Z,E0] = calibrate_spectrum_fit(l,Z)

if isrow(l)
    l = l';
end
if isrow(Z)
    Z = Z';
end

l = calibrate_spectrum_finding_max(l,Z);

% Calculate Gaussian function fitting range

[~,locs] = max(Z);


aprox_E0 = l(locs);
aprox_W0 = fwhm(l,Z);

[~,lpos] = min(abs(l-(aprox_E0-0.5*aprox_W0)));
[~,rpos] = min(abs(l-(aprox_E0+0.5*aprox_W0)));

E0 = 0;
if rpos - lpos + 1 > 2
    fun = fit(l(lpos:rpos),Z(lpos:rpos),'gauss1',...
        'StartPoint',[max(Z(lpos:rpos)),l(floor((lpos+rpos)/2)),fwhm(l,Z)],...
        'Lower',[0,l(lpos),mean(diff(l))]);
    E0 = fun.b1;
end

calibrated_e_loss = l - E0;

end