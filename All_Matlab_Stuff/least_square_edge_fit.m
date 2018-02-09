clc
close all

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
%Z = EELS_sum_spectrum(EELS);
llow = EELS.energy_loss_axis';
Z = normpdf(llow,0,2.5);
[llow,Z] = calibrate_zero_loss_peak(llow,Z);
figure;
plotEELS(llow,Z)
Zn = shift_zlp(Z,llow);
lcor = llow+100;
S = create_ionization_edge(512,1E4,0.01,lcor);
pS = conv(S,ifftshift(Zn/sum(Zn)));%+rand(1,2047)'*1000;

%% Cross sections

E = create_ionization_edge(512,10,0.01,lcor); %artificial cross section

pE = conv(E,ifftshift(Zn/sum(Zn)));%+rand(1,2047)'*0.1;


%%

f = @(a,pE) a(1)*pE+a(2);

a = lsqcurvefit(f,[1,1],pE(1:1024),pS(1:1024));

plot(pS)
hold on
plot(a(1)*pE+a(2))

R = deconv(a(1)*pE,ifftshift(Zn/sum(Zn)));

plot(S)
hold on
plot(R)
