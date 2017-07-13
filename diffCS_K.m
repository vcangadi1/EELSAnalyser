function dcs = diffCS_K(Z, Edge_onset_eV, E0, beta, energy_loss_axis)
%%
%   Input :
%                  Z = Atomic number
%           onset_ch = Edge onset channel number
%                 E0 = Beam Voltage in eV
%               beta = Collection angle
%   energy_loss_axis = Energy loss axis
%
%   Output :
%                dcs = Differential cross section
%
%%

% energy loss axis should be a column vector
if isrow(energy_loss_axis)
    l = energy_loss_axis';
else
    l = energy_loss_axis;
end

% Edge onset should be within the energy loss axis
if Edge_onset_eV < l(1) || Edge_onset_eV >= l(end)
    error('Edge onset value must be within the energy loss axis boundary');
end

% Get the total range
d = mean(diff(l));
rng = l-l(1)+d;

% Find onset channel
[~,onset_ch] = min(abs(l - Edge_onset_eV));

%% Calculate differential cross section

difcs = diff(arrayfun(@(ii) Sigmak3(Z,Edge_onset_eV,ii,E0,beta), rng));

%% Arrange the core-loss to be at the edge onset

dcs = [zeros(onset_ch,1);difcs(1:(length(l)-onset_ch+1))];
dcs = dcs(1:end-1);

