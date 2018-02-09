function [W0,E0,A0,Wp,Ep,Ap,V,gofv] = voigt_fit(energy_loss_axis,low_loss_spectrum)
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

[~,idx] = max(Z);
l = l-l(idx);

%% Find location of minimum between zero-loss peak and plasmon peak

aprox_E0 = l(idx);
aprox_W0 = fwhm(l,Z);

% Calculate Gaussian function fitting range

[~,lpos] = min(abs(l-(aprox_E0-0.5*aprox_W0)));
[~,rpos] = min(abs(l-(aprox_E0+0.5*aprox_W0)));

if lpos < rpos && rpos - lpos + 1 < 3
    lpos = lpos - 1;
    rpos = rpos + 1;
elseif rpos <= lpos
    lpos = lpos - 1;
    rpos = rpos + 1;
end

[fun,gofv] = fit(l(lpos:rpos),Z(lpos:rpos),'gauss1',...
    'StartPoint',[max(Z(lpos:rpos)),l(floor((lpos+rpos)/2)),fwhm(l,Z)],...
    'Lower',[0,l(lpos),mean(diff(l))]);

fprintf('fit range = %feV to %feV\n',l(lpos),l(rpos));
%plot(fun,l,Z)

W0 = fun.c1 * 2*sqrt(log(2));
E0 = fun.b1;
A0 = fun.a1 * (W0./(2*sqrt(2*log(2)))) * sqrt(2*pi);
G = @(E,E0,W0) 1./(W0./(2*sqrt(log(4))))./sqrt(2*pi)*exp(-((E-E0)/(sqrt(2) * (W0./(2*sqrt(log(4)))))).^2);
%plotEELS(l,Z)
%plotEELS(l,A*G(l,E0,W0))

%%

%fit_error = @(p) 

%options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});

%p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);

