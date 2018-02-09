function tlambda = thickness_map(EELS)
%% PARALLEL ROUTINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       EELS - EELS data structure. Low-loss spectrum data cube.
%
% Output:
%    tlambda - Thickness map. Each pixel value is $t/\lambda$ value of the
%              respective spectrum.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check for parallel workers

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolobj = parpool;
end

%% Thickness map
S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));

EELS = calibrate_zero_loss_peak(EELS);
l = @(ii,jj) squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));

tlambda = zeros(EELS.SI_x,EELS.SI_y);

id = zeros(EELS.SI_x, 1);
s = id;
f = id;

parfor_progress(EELS.SI_x);

%
tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    tlambda(ii,:) = arrayfun(@(jj) tbylambda(l(ii,jj),S(ii,jj)), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;

% delete parallel pool object
%delete(poolobj);

plotIntervals(s, f, id, min(s)); % plotIntervals
