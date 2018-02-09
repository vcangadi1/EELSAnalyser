clc
close all
%%
%{
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
if iscolumn(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis;
else
    l = EELS.energy_loss_axis';
end

S = EELS_sum_spectrum(EELS);
S_data = [l,S];

b = feval(Power_law(l(100:265),S(100:265)),l);
bS = S-b;
bS(1:264) = 0;
bS(bS<0) = 0;

%% Create a core-loss

Delta_limit = 1024-265;
d = 1;

C1 = [zeros(265,1); gradient(arrayfun(@(ii) Sigmal3(31,ii,198,15), (1:d:Delta_limit)'))];
C1 = medfilt1(hampel(medfilt1(C1)));

Delta_limit = 1024-473;
d = 1;

C2 = [zeros(473,1); gradient(arrayfun(@(ii) Sigmal3(33,ii,198,15), (1:d:Delta_limit)'))];
C2 = medfilt1(hampel(medfilt1(C2)));

%%
C = [C1,C2];
fun = @(a,C) a(1)*C(:,1)+(a(1)+a(2))*C(:,2);

a = lsqcurvefit(fun,[1,1],C,bS);

%%
plotEELS(l,bS)
hold on
%plotEELS(l,a*C'+b')

plotEELS(l,a*C')
%}

%%

EELS = readEELSdata('InGaN/100kV/EELS Spectrum Image6-b.dm3');

S = EELS_sum_spectrum(EELS);
l = EELS.energy_loss_axis;

%%
Ncs = cross_section(7,113,'k',100,45,170-113,l);

EELZ = readEELSdata('InGaN/100kV/EELS Spectrum Image8-lowloss.dm3');
Zn = EELS_sum_spectrum(EELZ);
Zn(Zn<0)=0;

Z = resample(Zn,1,2);
Z(Z<0)=0;
Z(110:end) = medfilt1(Z(110:end),10,'omitnan','truncate');

%%
tNcs = cross_section(7,113,'k',100,45,EELS.SI_z-113,l);

pNcs = plural_scattering(tNcs,Z);
pNcs = pNcs(1:170);

%% Background subtraction

b = feval(Power_law(l(1:110),S(1:110)),l);
bN = S(1:170) - b(1:170);
bN(1:113) = 0;
%bN(bN<0)=0;

%%

fun = @(a,pNcs) a*pNcs;
a = lsqcurvefit(fun,1,pNcs(1:170),bN);
disp(a);

%%
pN = pNcs(1:170);
%bN(bN<0)=0;

fit_error = @(mu) sum((bN - a*cross_section(7,mu,'k',100,45,170-mu,l)).^2);
%fit_error = @(mu) sum((Z - normpdf(llow,mu,Sig)).^2);

a0 = 113;

best_mu = fminsearch(fit_error, a0);

%%
Ncs_n = cross_section(7,round(best_mu),'k',100,45,200,l);
pNcs_n = plural_scattering(Ncs_n,Z);
pNcs_n = pNcs_n(1:170);

fun = @(a,pNcs) a*pNcs;
a = lsqcurvefit(fun,1,pNcs_n(1:170),bN);
disp(a)
%%
N = b+a*cross_section(7,best_mu,'k',100,45,1024-round(best_mu),l);

%%
plotEELS(l(1:170),bN)
hold on
plotEELS(l(1:170),a*pNcs_n)
