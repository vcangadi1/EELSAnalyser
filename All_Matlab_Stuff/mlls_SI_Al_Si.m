clc
clear all

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/AlNTb-P14-800degree/EELS Spectrum Image1-thickness-map.dm3');

EELS = calibrate_zero_loss_peak(EELS);

%%
%S = squeeze(res(20,95,300:344));
%Z = EELS_sum_spectrum(EELS);


l = EELS.energy_loss_axis;

dcsAl = diffCS_L23(13,73,60,45,l);
dcsSi = diffCS_L23(14,100,60,45,l);

%pdcsAl = plural_scattering(dcsAl,Z);

%%
for ii = EELS.SI_x:-1:1
    for jj = EELS.SI_y:-1:1
        S = squeeze(res(ii,jj,300:400));
        Z = EELS.S(ii,jj);
        pdcsAl = plural_scattering(dcsAl,Z);
        pdcsSi = plural_scattering(dcsSi,Z);
        
        fit_error = @(A) sum((S - (A(1) * pdcsAl(300:400) + A(2) * pdcsSi(300:400))).^2);
        
        N = fminsearch(fit_error,[1,1])*1250;
        AlMap(ii,jj) = N(1);
        SiMap(ii,jj) = N(2);
    end
end

%%

plotEELS(l(300:344),pdcsSi(300:344)*N)
hold on
plotEELS(l(300:344),S*1250)

%%
figure

plotEELS(l,squeeze(lloss(20,95,:))*1250+N*pdcsSi)
hold on
plotEELS(l,EELS.S(20,95)*1250)