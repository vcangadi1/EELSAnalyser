clc

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/AlNTb-P14-800degree/EELS Spectrum Image1-thickness-map.dm3');

EELS = calibrate_zero_loss_peak(EELS);

%%

l = EELS.energy_loss_axis;
dcs = diffCS_L23(13,73,60,45,l);

%%

p1 = 20;
p2 = 95;

s1 = 300;
s2 = 344;



%S = squeeze(res(p1,p2,s1:s2));
S1 = EELS_sum_spectrum(EELS);
S = S1(s1:s2);

Z = EELS_sum_spectrum(EELS);


pdcs = plural_scattering(dcs,Z);

fit_error = @(A) sum((S - A * pdcs(s1:s2)).^2);
N = fminsearch(fit_error,1)*1250;

%%

plotEELS(l(s1:s2),pdcs(s1:s2)*N)
hold on
plotEELS(l(s1:s2),S*1250)

%%
figure

plotEELS(l,squeeze(lloss(p1,p2,:))*1250+N*pdcs)
hold on
%plotEELS(l,EELS.S(p1,p2)*1250)
plotEELS(l,S1*1250)
