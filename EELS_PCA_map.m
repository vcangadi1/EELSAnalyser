function CompMap = EELS_PCA_map(EELS, model_begin_channel, model_end_channel, edge_onset_channel, num_delta_channel, model_options)

%EELS = readEELSdata('C:\Users\elp13va.VIE\Dropbox\MATLAB\AlNTb-P14-800degree\EELS Spectrum Image1.dm3');
%model_begin_channel = 13;
%model_end_channel = 28;
%edge_onset_channel = 28;
%num_delta_channel = 40;
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

IE = zeros(EELS.SI_x,EELS.SI_y,num_delta_channel);

b = model_begin_channel;
e = model_end_channel;
onset = edge_onset_channel;
d = num_delta_channel;

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

if strcmpi(model_options,'pow')
    fun = @(Sp) feval(Power_law(l(b:e),Sp(b:e)),l(onset:onset+d-1));
elseif strcmpi(model_options,'exp')
    fun = @(Sp) feval(Exponential_fit(l(b:e),Sp(b:e)),l(onset:onset+d-1));clc
end

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x,
    s(ii) = now; % plotIntervals data
    IE(ii,:,:) = cell2mat(arrayfun(@(jj) fun(S(ii,jj)), c.Value,'UniformOutput',false)')';
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
end
toc;

%%
IE = EELS.SImage(:,:,onset:onset+d-1)-IE;
IE = EELSmatrix(IE);

%%
%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals

%% Compute PCA

[COEFF,SCORE,LATENT] = pca(IE,'centered',false);

Z = length(LATENT);

CompMap = zeros(Z,EELS.SI_x,EELS.SI_y);

tic;
for ii = 1:Z,
    C = zeros(size(COEFF));
    C(:,ii) = COEFF(:,ii);
    CompMap(ii,:,:) = EELScube(sum(SCORE*C'),EELS.SI_x,EELS.SI_y);
end
toc;

%% Plot first 4 components
if Z > 3
    figure;
    subplot 221
    plotEELS(squeeze(CompMap(1,:,:)),'map'); title('Comp No 1');
    subplot 222
    plotEELS(squeeze(CompMap(2,:,:)),'map'); title('Comp No 2');
    subplot 223
    plotEELS(squeeze(CompMap(3,:,:)),'map'); title('Comp No 3');
    subplot 224
    plotEELS(squeeze(CompMap(4,:,:)),'map'); title('Comp No 4');
elseif Z > 2
    figure;
    subplot 131
    plotEELS(squeeze(CompMap(1,:,:)),'map'); title('Comp No 1');
    subplot 132
    plotEELS(squeeze(CompMap(2,:,:)),'map'); title('Comp No 2');
    subplot 133
    plotEELS(squeeze(CompMap(3,:,:)),'map'); title('Comp No 3');
elseif Z > 1
    figure;
    subplot 121
    plotEELS(squeeze(CompMap(1,:,:)),'map'); title('Comp No 1');
    subplot 122
    plotEELS(squeeze(CompMap(2,:,:)),'map'); title('Comp No 2');
end
