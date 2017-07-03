function [Wpv,Epv,Apv,m,PV,gof] = pseudo_voigt_fit(energy_loss_axis,low_loss_spectrum)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       low_loss_spectrum - Zero-loss peak (low loss spectrum)
%
% Output:
%                 I0 - Zero-loss intergral value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Copy input variables to local variables
if isrow(energy_loss_axis)
    l = energy_loss_axis';
else
    l = energy_loss_axis;
end

if isrow(low_loss_spectrum)
    Z = low_loss_spectrum';
else
    Z = low_loss_spectrum;
end

%% Calibrate energy loss axis
fittype = 'd*(a.*(1./pi).*(c./2)./((x - b).^2 + (c./2).^2) + (1-a)./(e./(2*sqrt(log(4))))./sqrt(2*pi).*exp(-((x-f)/(sqrt(2) * (e./(2*sqrt(log(4)))))).^2))';
lb = [0,-2.8,1,0,1,-2];
ub = [1,2,5,1E20,5,0.2];
st = [0.5,0,2,1E5,2,0];
[PV,gof] = fit(l,Z,fittype,'Lower',lb,'Upper',ub,'StartPoint',st);

Wpv = [PV.c PV.e];
Epv = [PV.b PV.f];
Apv = PV.d;
m = PV.a;
PV = @(E,Wpv,Epv,m) (m.*(1./pi).*(Wpv(1)./2)./((E - Epv(1)).^2 + (Wpv(1)./2).^2) + (1-m)./(Wpv(2)./(2*sqrt(log(4))))./sqrt(2*pi).*exp(-((E-Epv(2))/(sqrt(2) * (Wpv(2)./(2*sqrt(log(4)))))).^2));
