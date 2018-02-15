function dcs = diffCS_M45(Z, Edge_onset_eV, E0, beta, energy_loss_axis, Extrapolate_Option)
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
% Extrapolation options
if nargin < 6
    Extrapolate_Option = 'Exp';
end

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
r = l-l(1)+d;

% Find onset channel
[~,onset_ch] = min(abs(l - Edge_onset_eV));

%% Calculate differential cross section

%difcs = gradient(arrayfun(@(ii) Sigpar(Z,r(ii),'M45',E0,beta(ii))/10^-24, (1:247)'));
difcs = diff(arrayfun(@(ii) Sigpar(Z,r(ii),'M45',E0,beta(ii)), (1:247)'));


%% Extrapolate from 247 points to end of spectrum (1024 or 2048 pixels)

x = r(247-100:246);
y = difcs(247-100:246);

switch Extrapolate_Option
    case {'Exp','exp','Exponential','exponential'}
        Extraplt = feval(Exponential_fit(x,y),r(248:end));
    case {'Pow','pow','Power-law'}
        Extraplt = feval(Power_law(x,y),r(248:end));
    case {'ExpPow','exppow','avg'}
        Exp = feval(Exponential_fit(x,y),r(248:end));
        Pow = feval(Power_law(x,y),r(248:end));
        Extraplt = (Exp+Pow)/2;
end

difcs = [difcs(1:246);Extraplt];

%% Arrange the core-loss to be at the edge onset

dcs = [zeros(onset_ch,1);difcs(1:(length(l)-onset_ch))];

