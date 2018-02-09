clc
close all
clear all
%%
EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
%plotEELS(EELS)

%S = EELS_sum_spectrum(EELS);
S = EELS.S(10,58);
l = EELS.energy_loss_axis;

%%
%SS = S.*S;

%%
[l,SS] = calibrate_zero_loss_peak(l,S);

%%
[~,minidx] = min(abs(l-0.7));
[~,maxidx] = min(abs(l-3.4));
[~,limitidx] = min(abs(l-3.4));

%{
fit_error = @(A) sum((SS(minidx:limitidx) - (A(1)*sqrt(l(minidx:limitidx)-A(2))+A(3))).^2);

A0 = [100,3,10];

best_A = fminsearch(fit_error, A0);
%}
%%

fun = @(A,l) A(1)*sqrt(l(minidx:limitidx)-A(2))+A(3);

x0 = [100,3,10];

lb = [1 0.7 1];
ub = [1E6 6.6 1000];

A = real(lsqcurvefit(fun,x0,l,SS(minidx:limitidx),lb,ub));

%%
plot(l,A(1)*sqrt(l-A(2))+A(3));
hold on
plot(l,S);