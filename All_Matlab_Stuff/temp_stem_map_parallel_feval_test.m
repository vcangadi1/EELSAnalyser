function Map = temp_stem_map_parallel_feval_test(EELS, model_begin_channel, model_end_channel, edge_onset_channel, delta_channel, model_options)

%%
if nargin<6
    model_options = 'pow';
end

if isrow(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis';
else
    l = EELS.energy_loss_axis;
end

if isfield(EELS,'S')
    S = EELS.S;
else
    S = @(SI_x,SI_y) squeeze(EELS.SImage(SI_x,SI_y,:));
end

Map = zeros(EELS.SI_x,EELS.SI_y);

b = model_begin_channel;
e = model_end_channel;
onset = edge_onset_channel;
d = delta_channel;

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

if strcmpi(model_options,'pow')
    fun = @(Sp) sum(Sp(onset:onset+d) - feval(Power_law(l(b:e),Sp(b:e)),l(onset:onset+d)));
elseif strcmpi(model_options,'exp')
    fun = @(Sp) sum(Sp(onset:onset+d) - feval(Exponential_fit(l(b:e),Sp(b:e)),l(onset:onset+d)));
end

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x,
    s(ii) = now; % plotIntervals data
    Map(ii,:) = arrayfun(@(jj) fun(S(ii,jj)), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
end
toc;


Map = Map.*EELS.dispersion;

%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals
