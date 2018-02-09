clc
close all
clear all

%% Load series_1

I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/series1-10eV/GaN.1_sum.mat');
%S = I.I(537:567,:);
S = I.I(530:570,:);

SS = sum(S)';
l = (1:length(SS))'*0.05;
l = calibrate_zero_loss_peak(l,SS,'gauss');

%% Subtract Plasmons from each row


for ii = size(S,1):-1:1
    [Wp,Ep,Ap,L,gofp] = plasmon_fit(l,S(ii,:));
    S(ii,:) = S(ii,:) - Ap*L(l,Ep,Wp)';
    rsq_plasmon(ii) = gofp.rsquare;
end


%% Load ZLP series

I = load('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/ZL_0.1s/ZLPseries_sum.mat');
%Z = I.I(540:570,:);
Z = I.I(535:565,:);
ZZ = sum(Z)';
lz = calibrate_zero_loss_peak(l,ZZ,'gauss');


%% RL Deconvolution

J = deconvlucy(edgetaper(S,fspecial('gaussian',[15,50],100))+1E3,Z/sum(Z(:)),15)-1E3;
JJ = sum(J)';
lj = calibrate_zero_loss_peak(l,sum(J)','gauss');

%% Squre-root function

minidx = eV2ch(lj,4);
maxidx = eV2ch(lj,9);

%{
fun = @(p) real(p(1)*(lj(minidx:maxidx)-p(2)).^p(3));
p0 = [1E3,2.5,0.5];
lb = [1E2,0,.1];
ub = [1E50,6,0.8];
fit_error = @(p) sum(smooth(JJ(minidx:maxidx),10) - fun(p)).^2;
options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});
p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);
fprintf('bandgap = %f\t R-square = %f\n',p(2),rsquare(JJ(minidx:maxidx),fun(p)));
Bg_sqrt = p(2);
figure;
plotEELS(lj(minidx:maxidx), JJ(minidx:maxidx))
plotEELS(lj(minidx:maxidx), fun(p))
%}

%[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^c+d','upper',[10000,5,1.5,1000],'lower',[1,0.01,0.1,0],'StartPoint',[500,3,0.5,10])
[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^0.5+d','upper',[10000,5,1000],'lower',[1,0.01,0],'StartPoint',[500,3,10])
%[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^c','upper',[10000,5,1],'lower',[1,0.01,0.1],'StartPoint',[500,3,0.5])
%[f,gof] = fit(lj(minidx:maxidx),JJ(minidx:maxidx),'a*sqrt_fun(x,b).^0.5','upper',[1000,5],'lower',[1,0.01],'StartPoint',[500,3])


fprintf('bandgap = %.4f\t R-square = %.4f\n',f.b,gof.rsquare);

Bg_sqrt = f.b;

%figure;
%plotEELS(lj(minidx:maxidx), JJ(minidx:maxidx))
%plotEELS(lj(minidx:maxidx), feval(f,lj(minidx:maxidx)))

%% Differential method

dSS = diff(smooth(JJ(minidx:maxidx),10));

[~,idx] = max(smooth(dSS(1:end-5),10));

Bg_diff = lj(minidx+idx);

fprintf('bandgap = %f\n',Bg_diff);

%% plot

%figure;
%plotEELS(l,smooth(SS,10))
%plotEELS(lj,smooth(JJ,10))