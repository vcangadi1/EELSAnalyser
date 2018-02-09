function [p, R2, fun, back] = stem_map_mlls_fit(EELS, model_begin_channel, model_end_channel, Diff_cross_sections, Optional_EELZ_low_loss)
%%


%% Load spectrum
S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));
ll = @(ii,jj) squeeze(Optional_EELZ_low_loss.SImage(ii,jj,:));

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
p = ones(90,43,size(dfc,2));
back = ones(90,43,length(l));

for ii = 90:-1:1
    for jj = 43:-1:1
        [p(ii,jj,:), R2(ii,jj), ~, back(ii,jj,:)] = mlls_fit(S(ii,jj), l, b, e, dfc, ll(ii,jj));
        fprintf('(%d,%d) pixel\n',ii,jj);
    end
end

fun = @(p) dfc * p';