function W0_map = zero_loss_width_map(EELS)
%% PARALLEL ROUTINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       EELS - EELS data structure. Low-loss spectrum data cube.
%
% Output:
%    Wp_map - Zero loss width map. Each pixel value is fwhm value of zlp of
%              the respective spectrum.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check for parallel workers
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolobj = parpool;
end

%% Plasmon map

if iscolumn(EELS.energy_loss_axis)
    llow = EELS.energy_loss_axis;
else
    llow = EELS.energy_loss_axis';
end

S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));

W0_map = zeros(EELS.SI_x,EELS.SI_y);

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

parfor_progress(EELS.SI_x);

c = parallel.pool.Constant(1:EELS.SI_y);
tic;
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    W0_map(ii,:) = arrayfun(@(jj) zero_loss_fit(llow,S(ii,jj)), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;


% delete parallel pool object
delete(poolobj);

%%
%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals
end