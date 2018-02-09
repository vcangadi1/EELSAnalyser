clc
close all


EELS = readEELSdata;
A = EELSmatrix(EELS.SImage);

w = 10;
S = A(:,1);

h1 = hankel(S);
h2 = h1(:,1:w);
dilateS = max(h2, [], 2);

h3 = hankel(dilateS);
h4 = h3(:,1:w);
closeS = min(h4, [], 2);

plot(EELS.energy_loss_axis,A(:,1),'LineWidth',1)
hold on
plot(EELS.energy_loss_axis,dilateS,'LineWidth',1)
plot(EELS.energy_loss_axis,closeS,'LineWidth',1)