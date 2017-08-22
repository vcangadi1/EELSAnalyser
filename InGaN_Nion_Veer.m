clc

%%
[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-13.005),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-27.48),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);

l = @(ii,jj) squeeze(EELS.calibrated_energy_loss_axis(ii,jj,minidx(8,58):maxidx(8,58)));

S = @(ii,jj) squeeze(SImage(ii,jj,:));
%S1 = hampel(S(5,58),17);


%% Remove spike artifacts
SImage = medfilt1(SImage,20,[],3,'truncate');

%%
[GaN,InN,~] = referenced_InGaN('ll_1_20.csv');
InN(isnan(InN)) = 0;
GaN(isnan(GaN)) = 0;


%%

FWHM = @(x) 4.187+4.73727.*x-5.09438.*x.^2;
E_off = @(x) 4.1355+0.14256.*x+1.03625.*x.^2;
Ep = @(x) 19.55-E_off(x).*x;

cInGaN = @(ii,jj,x) InGaN_cl(InN, GaN, x, E_off(x),l(ii,jj));
%pInGaN = @(ii,jj,x) (2./pi)*(FWHM(x)./(4*(l(ii,jj)-Ep(x)).^2+FWHM(x).^2));
pInGaN = @(ii,jj,x) lorentz(l(ii,jj), Ep(x), FWHM(x));

P = @(ii,jj,p) p(1)*pInGaN(ii,jj,0)+p(2)*pInGaN(ii,jj,p(3))+p(4)*pInGaN(ii,jj,1);
C = @(ii,jj,p) p(1)*cInGaN(ii,jj,0)+p(2)*cInGaN(ii,jj,p(3))+p(4)*cInGaN(ii,jj,1);

%fun = @(p) (hampel(S(20,20),17) - P(20,20,p(1:4)) - C(20,20,p(5:8))).^2;
fun = @(p,l) p(9)*P(20,20,p(1:4)) + p(10)*C(20,20,p(5:8));

lb = [1,1,1E-10,1,1,1,1E-10,1,1,1];
ub = [1E10,1E10,1-1E-6,1E10,1E10,1E10,1-1E-6,1E10,1E10,1E10];

p0 = [1E4,1E4,0.5,1E4,1E4,1E4,0.5,1E4,1E4,1E4];

%p = lsqnonlin(fun,p0,lb,ub);
%p = fminsearch(fun,p0);
S1 = hampel(S(20,20),17);
options = optimoptions(@lsqcurvefit,'display','none');
p = lsqcurvefit(fun,p0,l(20,20),S1,lb,ub,options);



