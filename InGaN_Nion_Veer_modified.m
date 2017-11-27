clc
close all
clear all
%%

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');

%% calibrate zlp
EELS = calibrate_zero_loss_peak(EELS);


%%
[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-13.005),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-27.48),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);

l = @(ii,jj) squeeze(EELS.calibrated_energy_loss_axis(ii,jj,minidx(8,58):maxidx(8,58)));

S = @(ii,jj) hampel(squeeze(SImage(ii,jj,:)),17);
%S1 = hampel(S(5,58),17);


%% Remove spike artifacts
SImage = medfilt1(SImage,20,[],3,'truncate');


%% Plasmon Peak Model

FWHM = @(x) 4.187+4.73727.*x-5.09438.*x.^2;
E_off = @(x) 4.1355+0.14256.*x+1.03625.*x.^2;
%Ep = @(x) 19.35-E_off(x).*x;
%Ga plasmon is 19.35eV but spectrum is not calibrated exactly. Hence
%19.55eV is used.
Ep = @(x) 19.55-4.02.*x;
A = 21110.50558;

pInGaN = @(ii,jj,x) A.*lorentz(l(ii,jj), Ep(x), FWHM(x));

%% Core-loss Model

[GaN,InN,~] = referenced_InGaN('ll_1_20.csv');
InN(isnan(InN)) = 0;
GaN(isnan(GaN)) = 0;

cInGaN = @(ii,jj,x) InGaN_cl_modified(InN, GaN, x, E_off(x),l(ii,jj));


%P = @(ii,jj,p) p(1)*pInGaN(ii,jj,0)+p(2)*pInGaN(ii,jj,p(3))+p(4)*pInGaN(ii,jj,1);
%C = @(ii,jj,p) p(1)*cInGaN(ii,jj,0)+p(2)*cInGaN(ii,jj,p(3))+p(4)*cInGaN(ii,jj,1);

%fun = @(p) (hampel(S(3,59),17) - P(3,59,p(1:4)) - C(3,59,p(5:8))).^2;
%fun = @(p,l) p(9)*P(3,59,p(1:4)) + p(10)*C(3,59,p(5:8));

%lb = [1,1,1E-10,1,1,1,1E-10,1,1,1];
%ub = [1E10,1E10,1-1E-6,1E10,1E10,1E100,1-1E-6,1E100,1E100,1E100];

%p0 = [1E4,1E4,0.5,1E4,1E4,1E10,0.5,1E10,1E10,1E10];

%p = lsqnonlin(fun,p0,lb,ub);
%p = fminsearch(fun,p0);
%S1 = hampel(S(3,59),17);
%options = optimoptions(@lsqcurvefit,'display','none');
%p = lsqcurvefit(fun,p0,l(3,59),S1,lb,ub,options);

%%
m = 10000;
%X = @(ii,jj,xx) [pInGaN(ii,jj,0) pInGaN(ii,jj,xx/m) pInGaN(ii,jj,1) cInGaN(ii,jj,0) cInGaN(ii,jj,xx/m) cInGaN(ii,jj,1) l(ii,jj) ones(length(l(ii,jj)),1)];
X = @(ii,jj,xx) [pInGaN(ii,jj,0) pInGaN(ii,jj,xx/m) pInGaN(ii,jj,1) cInGaN(ii,jj,0) cInGaN(ii,jj,xx/m) cInGaN(ii,jj,1)];

tic;
for ii = EELS.SI_x:-1:1
    for jj = EELS.SI_y:-1:1
        for xx = m-1:-1:1
            p(ii,jj,1:6,xx) = regress(S(ii,jj), X(ii,jj,xx));
            r2(ii,jj,xx) = rsquare(S(ii,jj),squeeze(p(ii,jj,1:6,xx))'*X(ii,jj,xx)');
        end
        [~,c(ii,jj)] = max(squeeze(r2(ii,jj,:)));
        fprintf('(%d,%d) finished\n',ii,jj);
        GaNp(ii,jj) = squeeze(p(ii,jj,1,c(ii,jj)));
        InGaNp(ii,jj) = squeeze(p(ii,jj,2,c(ii,jj)));
        InNp(ii,jj) = squeeze(p(ii,jj,3,c(ii,jj)));
        GaNc(ii,jj) = squeeze(p(ii,jj,4,c(ii,jj)));
        InGaNc(ii,jj) = squeeze(p(ii,jj,5,c(ii,jj)));
        InNc(ii,jj) = squeeze(p(ii,jj,6,c(ii,jj)));
        R2(ii,jj) = squeeze(r2(ii,jj,c(ii,jj)));
    end
end
toc;
%%

%x_value = [1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0];
%correction_to_sum = [2.204065904 2.008173594 1.836564383 1.68407018 1.549137032 1.433339148 1.326518424 1.230818344 1.145418392 1.064222791 1];
%f = polyfit(x_value,correction_to_sum,2);
%cor = @(ii,jj) polyval(f,c(ii,jj)/m);

cor = @(ii,jj) In_cl_trunc_corr(c(ii,jj)/m);

%%

for ii = 30:-1:1
    for jj = 60:-1:1
        fprintf('(%d,%d) finished\n',ii,jj);
        csum(ii,jj) = sum(cInGaN(ii,jj,0))*GaNc(ii,jj) + sum(cInGaN(ii,jj,c(ii,jj)/m))*InGaNc(ii,jj) + sum(cInGaN(ii,jj,1))*InNc(ii,jj);
        wcGaN(ii,jj) = sum(cInGaN(ii,jj,0))*GaNc(ii,jj)./csum(ii,jj);
        wcInN(ii,jj) = sum(cInGaN(ii,jj,1))*InNc(ii,jj)./csum(ii,jj); %correction applied in next step
        wcInGaN(ii,jj) = sum(cInGaN(ii,jj,c(ii,jj)/m))*InGaNc(ii,jj)./csum(ii,jj);%correction applied in next step
        psum(ii,jj) = sum(pInGaN(ii,jj,0))*GaNp(ii,jj) + sum(pInGaN(ii,jj,c(ii,jj)/m))*InGaNp(ii,jj) + sum(pInGaN(ii,jj,1))*InNp(ii,jj);
        wpGaN(ii,jj) = sum(pInGaN(ii,jj,0))*GaNp(ii,jj)./psum(ii,jj);
        wpInN(ii,jj) = sum(pInGaN(ii,jj,1))*InNp(ii,jj)./psum(ii,jj);
        wpInGaN(ii,jj) = sum(pInGaN(ii,jj,c(ii,jj)/m))*InGaNp(ii,jj)./psum(ii,jj);
    end
end

%% Truncation correction
load('/Users/veersaysit/Dropbox/PhD_Thesis/Low_loss_Plasmon_Coreloss_fit/maskInGaN.mat')
InGaN_cor = cor(1:30,1:60).*maskInGaN;
InGaN_cor(InGaN_cor==0) = 1;
wcInN = wcInN.*InGaN_cor.*BW;
wcInGaN = wcInGaN.*InGaN_cor.*BW;
wcGaN = wcGaN./InGaN_cor.*BW;


%% Indium content from core-loss and plasmon loss

load('/Users/veersaysit/Dropbox/PhD_Thesis/BW_InGaN.mat')
cIn = (wcInN + wcInGaN.*c/m).*BW;
pIn = (wpInN + wpInGaN.*c/m).*BW;
cGa = (wcGaN + wcInGaN.*(1-c/m)).*BW;
pGa = (wpGaN + wpInGaN.*(1-c/m)).*BW;

%%

ii = 16;
jj = 41;

figure;
plotEELS(l(ii,jj),S(ii,jj))
plotEELS(l(ii,jj),squeeze(p(ii,jj,1:6,c(ii,jj)))'*X(ii,jj,c(ii,jj))')
plotEELS(l(ii,jj),squeeze(p(ii,jj,3,c(ii,jj)))'*pInGaN(ii,jj,1)')
plotEELS(l(ii,jj),squeeze(p(ii,jj,2,c(ii,jj)))'*pInGaN(ii,jj,c(ii,jj)/m)')
plotEELS(l(ii,jj),squeeze(p(ii,jj,1,c(ii,jj)))'*pInGaN(ii,jj,0)')
plotEELS(l(ii,jj),squeeze(p(ii,jj,6,c(ii,jj)))'*cInGaN(ii,jj,1)')
plotEELS(l(ii,jj),squeeze(p(ii,jj,5,c(ii,jj)))'*cInGaN(ii,jj,c(ii,jj)/m)')
plotEELS(l(ii,jj),squeeze(p(ii,jj,4,c(ii,jj)))'*cInGaN(ii,jj,0)')
legend('Spectrum','Model fit','InN bulk plasmon','InGaN bulk plasmon',...
    'GaN bulk plasmon','InN core-loss','InGaN core-loss','GaN core-loss')
title(['x = ',num2str(c(ii,jj)/m)]);
%plotEELS(l(ii,jj),p(7,c)'*l(ii,jj)')
%plotEELS(l(ii,jj),p(8,c)'*ones(length(l(ii,jj)),1)')
grid minor
rsquare(S(ii,jj), squeeze(p(ii,jj,1:6,c(ii,jj)))'*X(ii,jj,c(ii,jj))')