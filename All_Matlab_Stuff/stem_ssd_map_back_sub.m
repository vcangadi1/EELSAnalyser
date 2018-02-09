function [ssdMap,psdMap,ssd,psd] = stem_ssd_map_back_sub(EELS, model_begin_channel, model_end_channel, edge_onset_channel, num_delta_channel, background_model_options, deconv_options)

%EELS = readEELSdata('C:\Users\elp13va.VIE\Dropbox\MATLAB\AlNTb-P14-800degree\EELS Spectrum Image1.dm3');
%{
model_begin_channel = 260;%235;
model_end_channel = 341;%301;
edge_onset_channel = 343;%305;
num_delta_channel = 50;%39;
background_model_options = 'exp2';

deconv_options.type = 'fourier_ratio';
deconv_options.ll_energy_axis = EELS.energy_loss_axis;
deconv_options.ll_spectrum = Z;
deconv_options.reconv = fwhm(EELS.energy_loss_axis,Z);
%}
%%

if nargin < 7
    fprintf('\nRequire folowing deconv_options:\n');
    fprintf('deconv_options.type\ndeconv_options.ll_energy_axis\n');
    fprintf('deconv_options.ll_spectrum\ndeconv_options.reconv\n');
    error('deconv_options input missing');
end

if nargin < 6
    background_model_options = 'pow';
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

b = model_begin_channel;
e = model_end_channel;
onset = edge_onset_channel;
d = num_delta_channel;

IE = zeros(size(EELS.SImage));

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

if strcmpi(background_model_options,'pow')
    fun = @(Sp) feval(Power_law(l(b:e),Sp(b:e)),l);
elseif strcmpi(background_model_options,'exp1')
    fun = @(Sp) feval(Exponential_fit(l(b:e),Sp(b:e),'exp1'),l);
elseif strcmpi(background_model_options,'exp2')
    fun = @(Sp) feval(Exponential_fit(l(b:e),Sp(b:e),'exp2'),l);    
end

parfor_progress(EELS.SI_x);

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    IE(ii,:,:) = cell2mat(arrayfun(@(jj) fun(S(ii,jj)), c.Value,'UniformOutput',false)')';
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;
%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals

%%
psd = EELS.SImage-IE;
psd(:,:,1:e) = 0;

%%
[ll_el,ll_S] = calibrate_zero_loss_peak(deconv_options.ll_energy_axis,...
                                            deconv_options.ll_spectrum,'gauss');
fwhm_zlp = deconv_options.reconv;

deconv_fun = @(Sp) Frat([ll_el,ll_S],fwhm_zlp,[l,Sp]);

pS = @(SI_x,SI_y) squeeze(psd(SI_x,SI_y,:));

ssd = zeros(size(EELS.SImage));

parfor_progress(EELS.SI_x);

tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    ssd(ii,:,:) = cell2mat(arrayfun(@(jj) deconv_fun(pS(ii,jj)), c.Value,'UniformOutput',false)')';
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;

%%
ssd(isnan(ssd)) = 0;
ssd(isinf(ssd)) = 0;

%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals

%%
%ssdMap = trapz(l(onset:onset+d),ssd(:,:,onset:onset+d),3);
%psdMap = trapz(l(onset:onset+d),psd(:,:,onset:onset+d),3);
ssdMap = sum(ssd(:,:,onset:onset+d),3);
psdMap = sum(psd(:,:,onset:onset+d),3);