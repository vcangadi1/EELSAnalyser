function [dcs,cs] = diffCS_K(Z, Edge_onset_eV, E0, Beta, energy_loss_axis)
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

% Check if bstar is same size as energy-loss axis
if length(Beta) == 1
    Beta = Beta*ones(size(l));
elseif length(Beta) ~= length(l)
    error('beta should be a single value or same length as energy-loss axis');
end

% Get the total range
d = mean(diff(l));
rng = l-l(1)+d;

% Find onset channel
[~,onset_ch] = min(abs(l - Edge_onset_eV));

%% Calculate differential cross section
cs = arrayfun(@(ii) Sigmak3(Z,Edge_onset_eV,rng(ii),E0,Beta(ii)), (1:length(rng))');
difcs = diff(cs);
%difcs = diff(arrayfun(@(ii) Sigmak3(Z,Edge_onset_eV,rng(ii),E0,Beta(ii)), (1:length(rng))'));


%% Arrange the core-loss to be at the edge onset

cs = [zeros(onset_ch,1);cs(1:(length(l)-onset_ch+1))];
cs = cs(1:end-1);
dcs = [zeros(onset_ch,1);difcs(1:(length(l)-onset_ch+1))];
dcs = dcs(1:end-1);

%% Remove spike noise due to differentiation
% Smooth with hampel filter

if onset_ch+25 <= length(l)
    dcs(onset_ch+20:end) = hampel(dcs(onset_ch+20:end),13);
end

if onset_ch+150 <= length(l)
    dcs(onset_ch+50:end) = feval(Exponential_fit(l(onset_ch+50:onset_ch+100),dcs(onset_ch+50:onset_ch+100),'exp1'),l(onset_ch+50:end));
end
