function [Wp, Ep, Ap, L, gofp] = plasmon_fit(energy_loss_axis, low_loss_spectrum)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%        energy_loss_axis - low loss energy-loss axis
%       low_loss_spectrum - Zero-loss and plasmon peaks (low loss spectrum)
%
% Output:
%                      Wp - Plasmon peak FWHM value in $eV$.
%                      Ep - Plasmon peak position value in $eV$.
%                       A - Amplitude (scaling) of Lorentzian fitting
%                       L - $L(E,Ep,Wp)$ Lorentz function,
%                           where E = energy loss axis
%                    gofp - Goodness of fit
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

%% Calibrate zero loss peak to 0eV

%[~,E0,~,~] = zero_loss_fit(l,Z);
%l = l - E0;

l = calibrate_zero_loss_peak(l,Z,'Gaussian');

%% Find approximate plasmon peak and width

aprox_Ep = plasmon_peak(l,Z);
%aprox_FWHM = plasmon_width(l,Z);
aprox_FWHM = 20;

%% Calculate Lorentz function fitting range

[~,lpos] = min(abs(l-(aprox_Ep-0.2*aprox_FWHM)));
[~,rpos] = min(abs(l-(aprox_Ep+0.12*aprox_FWHM)));

if lpos <= rpos && rpos - lpos + 1 < 3
    lpos = lpos - 1;
    rpos = rpos + 1;
end

%% Fit a 3 parameter Lorentz function

%[~,p] = lorentzfit(l(lpos:rpos),Z(lpos:rpos),[],[],'3');
[fun,gofp] = fit(l(lpos:rpos),Z(lpos:rpos),'Ap.* (1./pi) .* (Wp./2)./((x-Ep).^2+(Wp./2).^2)',...
    'StartPoint',[max(Z(lpos:rpos)),l(floor((lpos+rpos)/2)),aprox_FWHM],...
    'Lower',[0,l(lpos),mean(diff(l))]);

fprintf('fit range = %feV to %feV\n',l(lpos),l(rpos));

%% Assign fitting parameters to output variables

Wp = fun.Wp;
Ep = fun.Ep;
Ap = fun.Ap;
L = @(E,Ep,Wp) (1./pi) .* (Wp./2)./((E-Ep).^2+(Wp./2).^2);

%% Plot
%figure;
%plotEELS(l,Z)
%plotEELS(l,Ap*L(l,Ep,Wp))