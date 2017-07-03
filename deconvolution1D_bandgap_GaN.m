clc
close all
clear all

%% Load series_1

I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/series1-10eV/GaN.1_sum.mat');
%I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/series2-30eVoff/GaN.2_sum.mat');
%I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/series3-ADFimageMode-10eV/GaN.3_sum.mat');
S = I.I(537:567,:);
S(S<0) = 0;

%I = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/GaN_EELS_TEMmode250kX_0.6mm_Series1_Sum1-16_16s_0.05disp.dm3');
%S = I.Image(:,535:565)';

SS = sum(S)';
l = (1:length(SS))'*0.05;
l = calibrate_zero_loss_peak(l,SS,'gauss');

%% Subtract Plasmons from each row

[Wp,Ep,Ap,L,gofp] = plasmon_fit(l,SS);
SS = SS - Ap*L(l,Ep,Wp);
rsq_plasmon_1D = gofp.rsquare;

%% Load ZLP series

I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/ZL_0.1s/ZLPseries_sum.mat');
Z = I.I(540:570,:);
ZZ = sum(Z)';
lz = calibrate_zero_loss_peak(l,ZZ,'gauss');

%% RL Deconvolution

hSS = higher_grid_middle_smooth(SS);

JJ = deconvlucy(hSS,ZZ/sum(ZZ(:)),10);

%%%%%%%%%%%%%%%%%%%%%%%
%{
fhSS = flipZLP(hSS); % for ADF ring aperture
x = l(eV2ch(l,-l(1))-40:eV2ch(l,-l(1)));
y = fhSS(end-40:end);
f = feval(fit(x,y,'exp1'),l);
fhSS = [fhSS;f(eV2ch(l,-l(1))+1:end)];
JJ = deconvlucy(hSS,fhSS/sum(fhSS(:)),10); % for ADF ring aperture
%}
%%%%%%%%%%%%%%%%%%%%%%




plot(higher_grid_middle_smooth(SS))
JJ = JJ(513:1536);
lj = calibrate_zero_loss_peak(l,JJ,'gauss');

%% Squre-root function

minidx = eV2ch(lj,1);
maxidx = eV2ch(lj,8);
%{
fun = @(p) p(1)*sqrt_fun(lj(minidx:maxidx),p(2)).^p(3);
p0 = [5E2,3.4,0.5];
lb = [3E2,0,.3];
ub = [1E50,6,0.6];
fit_error = @(p) sum(smooth(JJ(minidx:maxidx),10) - fun(p)).^2;
options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});
p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);
fprintf('bandgap = %f\t R-square = %f\n',p(2),rsquare(JJ(minidx:maxidx),fun(p)));
Bg_sqrt = p(2);
figure;
plotEELS(lj(minidx:maxidx), JJ(minidx:maxidx))
plotEELS(lj(minidx:maxidx), fun(p))
%}

%[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^c+d','upper',[10000,5,1,1000],'lower',[1,0.7,0.1,0],'StartPoint',[500,3,0.5,10]);
%[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^c','upper',[10000,5,1],'lower',[1,0.7,0.1],'StartPoint',[500,3,0.5]);
[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^0.5','upper',[10000,5],'lower',[1,0.7],'StartPoint',[500,3]);

fprintf('bandgap = %f\t R-square = %f\n',f.b,gof.rsquare);

Bg_sqrt = f.b;

figure;
plotEELS(lj(minidx:maxidx), JJ(minidx:maxidx))
plotEELS(lj(minidx:maxidx), feval(f,lj(minidx:maxidx)))

%% Differential method

dSS = diff(smooth(JJ(minidx:maxidx),10));

[~,idx] = max(smooth(dSS(1:end-5),10));

Bg_diff = lj(minidx+idx);

fprintf('bandgap = %f\n',Bg_diff);

%% plot

figure;
plotEELS(l,SS)
plotEELS(lj,JJ)