clc
close all


EELS = readEELSdata;
A = EELSmatrix(EELS.SImage);

w = 10;
S = A(:,100);

h1 = hankel(S);
h2 = h1(:,1:w);
erodedS = min(h2, [], 2);

h3 = hankel(erodedS);
h4 = h3(:,1:w);
openS = max(h4, [], 2);

plot(EELS.energy_loss_axis,A(:,100),'LineWidth',1)
hold on
plot(EELS.energy_loss_axis,erodedS,'LineWidth',1)
plot(EELS.energy_loss_axis,openS,'LineWidth',1)