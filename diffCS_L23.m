function dcs = diffCS_L23(Atomic_Num, Edge_onset_eV, E0, beta, energy_loss_axis)
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
if length(beta) == 1
    beta = beta*ones(size(l));
elseif length(beta) ~= length(l)
    error('beta should be a single value or same length as energy-loss axis');
end

% Get the total range
d = mean(diff(l));
rng = l-l(1)+d;

% Find onset channel
[~,onset_ch] = min(abs(l - Edge_onset_eV));

%% Calculate differential cross section

difcs = zeros(size(l));
difcs(1:end-1) = diff(arrayfun(@(ii) Sigmal3(Atomic_Num,ii,E0,beta(ii)), rng));
difcs(end) = difcs(end-1);

%% Arrange the core-loss to be at the edge onset

dcs = [zeros(onset_ch,1);difcs(1:(length(l)-onset_ch))];

%% Remove spike noise due to differentiation
% Smooth with hampel filter

if onset_ch+25 <= length(l)
    dcs(onset_ch+20:end) = hampel(dcs(onset_ch+20:end),13);
end
