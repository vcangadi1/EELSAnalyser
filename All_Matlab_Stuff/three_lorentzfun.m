clc
close all
clear all
%%
EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);

S = EELS.S(14,38);
S(270:end) = medfilt1(S(270:end),20,'truncate');

l = squeeze(EELS.calibrated_energy_loss_axis(14,38,:));
%%

[~,minidx] = min(abs(l-15));
[~,maxidx] = min(abs(l-19.7));

x = l(minidx:maxidx);
y = S(minidx:maxidx);
%%

lfun = @(x,p) p(1)./ ((x-15.5).^2 + p(2).^2) + p(3)./ ((x-p(4)).^2 + p(5).^2) + p(6)./ ((x-19.54).^2 + p(7).^2);

p0 = [10,5,10,16,5,10,5];
%lb = [1,4,1,15.5,4,1,4];
%ub = [max(y),5.3,max(y),19.54,5.3,max(y),5.3];

[params,resnorm,residual] = lsqcurvefit(lfun,p0,x,y);

