clc; close all;
%%
%{
n=[-10:1:10];
x = 0*n;
x(n==7)=1;
h=normpdf(n,0,2);
y = conv(x,h);
plot(n,conv(h,x/sum(x),'same'))
hold on
plotEELS(n,h)
%}

%%

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')

llow = EELS.energy_loss_axis';

%Z = normpdf(llow,0,3);
Z = EELS_sum_spectrum(EELS);

[llow,Z] = calibrate_zero_loss_peak(llow,Z);

%Zn = shift_zlp(Z,llow);

%Zn = ifftshift(Zn);

%%

E = create_ionization_edge(300,1E4,0.01,llow);

%%
l = llow - llow(300);
Zn = shift_zlp(Z,llow);
Zn = ifftshift(Zn);

pE = conv(E,Zn/sum(Zn));

%%
hold on
plotEELS(llow,Zn)
plotEELS(llow,E)
plot(llow,conv(E,Zn/sum(Zn),'same'),'LineWidth',2)
hold off

figure;
hold on
plot(pE)
plot(E)
hold off


