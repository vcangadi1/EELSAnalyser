clc
clear all

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/AlNTb-P14-800degree/EELS Spectrum Image1-thickness-map.dm3');

S = EELS.S(66,97);
l = EELS.energy_loss_axis;
l = calibrate_zero_loss_peak(l,S,'gauss');

[W0,E0,A0,G] = zero_loss_fit(l,S);
[Wp,Ep,Ap,L] = plasmon_fit(l,S);

TOL = tbylambda(l,S);

N = floor(l(end)/Ep);
n = (0:N);

%% fit with TOL as fitting parameter
fun = @(p,l) (p(1)*(poisson(n,p(2))*[G(l,0,W0),L(l,n(2:end)*p(3),p(4))]')');
p0 = [1E5,TOL,Ep,Wp];
lb = [0,0,0,0];
ub = [inf,ceil(TOL)+1,1.5*Ep,Wp];
options = optimset('Display','off');
p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
figure;
plotEELS(l,S)
plotEELS(l,p(1)*(poisson(n,p(2))*[G(l,0,W0),L(l,n(2:end)*Ep,Wp)]')')
rsquare(S,p(1)*(poisson(n,p(2))*[G(l,0,W0),L(l,n(2:end)*Ep,Wp)]')')

%% Voigt function with TOL as fitting parameter
fun = @(p,l) (p(1)*(poisson(n,p(2))*[G(l,0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,0,W0)')]')');
p0 = [1E5,TOL,Ep,0.5*Wp];
lb = [0,0,0,0];
ub = [inf,10,1.5*Ep,Wp];
options = optimset('Display','off');
p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
figure;
plotEELS(l,S)
plotEELS(l,p(1)*(poisson(n,p(2))*[G(l,0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,0,W0)')]')')
rsquare(S,p(1)*(poisson(n,p(2))*[G(l,0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,0,W0)')]')')
