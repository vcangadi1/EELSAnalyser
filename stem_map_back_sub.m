function Map = stem_map_back_sub(EELS, model_begin_channel, model_end_channel, edge_onset_channel, num_delta_channel, background_model_options)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%                      EELS - EELS data structure
%       model_begin_channel - Start of fit channel number
%         model_end_channel - End of fit channel number
%        edge_onset_channel - Onset channel number
%         num_delta_channel - Integration range in terms of channel number
%  background_model_options - background model options 
%                             eg: 'pow', 'exp1', 'exp2'
% Output:
%                       Map - Elemental map with normalized exposure time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 

if nargin<6
    background_model_options = 'pow';
end

if isrow(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis';
else
    l = EELS.energy_loss_axis;
end

S = @(SI_x,SI_y) squeeze(EELS.SImage(SI_x,SI_y,:));

Map = zeros(EELS.SI_x,EELS.SI_y);

b = model_begin_channel;
e = model_end_channel;
onset = edge_onset_channel;
d = num_delta_channel;

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

%{
if strcmpi(background_model_options,'pow')
    fun = @(Sp) trapz(l(onset:onset+d),Sp(onset:onset+d) - feval(Power_law(l(b:e),Sp(b:e)),l(onset:onset+d)));
elseif strcmpi(background_model_options,'exp1')
    fun = @(Sp) trapz(l(onset:onset+d),Sp(onset:onset+d) - feval(Exponential_fit(l(b:e),Sp(b:e),'exp1'),l(onset:onset+d)));
elseif strcmpi(background_model_options,'exp2')
    fun = @(Sp) trapz(l(onset:onset+d),Sp(onset:onset+d) - feval(Exponential_fit(l(b:e),Sp(b:e),'exp2'),l(onset:onset+d)));
end
%}
if strcmpi(background_model_options,'pow')
    fun = @(Sp) sum(Sp(onset:onset+d) - feval(Power_law(l(b:e),Sp(b:e)),l(onset:onset+d)));
elseif strcmpi(background_model_options,'exp1')
    fun = @(Sp) sum(Sp(onset:onset+d) - feval(Exponential_fit(l(b:e),Sp(b:e),'exp1'),l(onset:onset+d)));
elseif strcmpi(background_model_options,'exp2')
    fun = @(Sp) sum(Sp(onset:onset+d) - feval(Exponential_fit(l(b:e),Sp(b:e),'exp2'),l(onset:onset+d)));
end

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    Map(ii,:) = arrayfun(@(jj) fun(S(ii,jj)), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
end
toc;

%% Normalize elemental maps to 1 second exposure time
if ~isempty(EELS.exposure_time_sec) && EELS.exposure_time_sec ~= 0
    Map = Map./EELS.exposure_time_sec;
    fprintf('\nElemental maps are normalized to 1 sec by dividing Map by exposure time\n');
    fprintf('Exposure time = %f sec\n', EELS.exposure_time_sec);
end

%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals
