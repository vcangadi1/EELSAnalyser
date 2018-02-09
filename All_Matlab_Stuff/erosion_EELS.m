clc
close all


EELS = readEELSdata;
A = EELSmatrix(EELS.SImage);

w = 6;
S = A(:,1);

h = hankel(S);
h1 = h(:,1:w);

%erodedS = min(h1, [], 2);
m = medfilt1(S,10);

plot(EELS.energy_loss_axis,A(:,1),'LineWidth',1)
hold on
plot(EELS.energy_loss_axis,m,'LineWidth',1)
