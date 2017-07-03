clc
clear all
close all

%%
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/profile_series1_gatan.dm3');
%EELS = readEELSdata;
I = EELS.spectrum;
l = calibrate_zero_loss_peak(EELS.energy_loss_axis,I,'gauss');
I = I(1:1024);
l = l(1:1024);

%%
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/ZLP_extracted_series1_gatan.dm3');
I0 = EELS.spectrum;
I0 = I0(1:1024);
tI0 = I0;
tI0(eV2ch(l,1.1):end) = feval(fit(l(eV2ch(l,1.1):eV2ch(l,10)),I0(eV2ch(l,1.1):eV2ch(l,10)),'exp2'),l(eV2ch(l,1.1):end));

%%

%[Wp,Ep,Ap,L,gofp] = plasmon_fit(l,I);
%tI = I - Ap*L(l,Ep,Wp);
%I = tI;

%%

it  = 10;

JJ = deconvlucy(higher_grid_middle_smooth(I)+1E10,tI0/sum(tI0(:)),it)-1E10;

dJ = deconvlucy(higher_grid_middle_smooth(tI0)+1E10,tI0/sum(tI0(:)),it)-1E10;

r = JJ(513:1024+512) - dJ(513:1024+512);

lj = calibrate_zero_loss_peak(l,JJ(513:1024+512),'gauss');

minidx = eV2ch(lj,1);
maxidx = eV2ch(lj,6); %change from 1eV to 8eV

[f,gof] = fit(lj(minidx:maxidx),r(minidx:maxidx),'a*sqrt_fun(x,b).^c+d','upper',[10000,5,1.5,1000],'lower',[1,0.7,0.1,-100],'StartPoint',[500,3,0.5,10])
%[f,gof] = fit(lj(minidx:maxidx),r(minidx:maxidx),'a*sqrt_fun(x,b).^0.5+d','upper',[10000,5,1000],'lower',[1,0.7,-100],'StartPoint',[500,3,10])
%[f,gof] = fit(lj(minidx:maxidx),r(minidx:maxidx),'a*sqrt_fun(x,b).^c','upper',[10000,5,1.5],'lower',[1,0.7,0.1],'StartPoint',[500,3,0.5])
%[f,gof] = fit(lj(minidx:maxidx),r(minidx:maxidx),'a*sqrt_fun(x,b).^0.5','upper',[10000,5],'lower',[1,0.7],'StartPoint',[500,3])


%%

dr = diff(smooth(r(minidx:maxidx),10));

[~,idx] = max(smooth(dr(1:end-5),10));

Bg_diff = lj(minidx+idx);

fprintf('bandgap = %f\n',Bg_diff);

