function [p, R2, fun, back] = stem_map_mlls_fit_modified(EELS, model_begin_channel, model_end_channel, Diff_cross_sections, Fit_Type, Optional_EELZ_low_loss)
%%


%% Load spectrum
S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));

%% Load energy-loss axis
if isrow(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis';
else
    l = EELS.energy_loss_axis;
end

%% background begin - end
b = model_begin_channel;
e = model_end_channel;

%% Differential cross-section
dfc = Diff_cross_sections;

%% stem mlls fit

switch Fit_Type
    case {'A','a'}
        p = ones(EELS.SI_x,EELS.SI_y,size(dfc,2)+2);
    case {'B','b'}
        p = ones(EELS.SI_x,EELS.SI_y,size(dfc,2)+1);
    case {'C','c'}
        p = ones(EELS.SI_x,EELS.SI_y,size(dfc,2)+3);
    case {'D','d','E','e'}
        p = ones(EELS.SI_x,EELS.SI_y,size(dfc,2)+4);
end

back = ones(EELS.SI_x,EELS.SI_y,length(l));

if nargin < 6
    tic;
    for ii = EELS.SI_x:-1:1
        for jj = EELS.SI_y:-1:1
            [p(ii,jj,:), R2(ii,jj), ~, back(ii,jj,:)] = mlls_fit_modified(S(ii,jj), l, b, e, dfc);
            fprintf('(%d,%d) pixel\n',ii,jj);
        end
    end
    toc;
else
    ll = @(ii,jj) squeeze(Optional_EELZ_low_loss.SImage(ii,jj,:));
    tic;
    for ii = EELS.SI_x:-1:1
        for jj = EELS.SI_y:-1:1
            [p(ii,jj,:), R2(ii,jj), ~, back(ii,jj,:)] = mlls_fit_modified(S(ii,jj), l, b, e, dfc, ll(ii,jj));
            fprintf('(%d,%d) pixel\n',ii,jj);
        end
    end
    toc;
end
fun = @(p) dfc * p';