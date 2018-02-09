clc
close all


EELS = readEELSdata;
A = EELSmatrix(EELS.SImage);

w = 5;
S = A(:,1);

h = hankel(S);
h1 = h(:,1:w);

dilateS = max(h1, [], 2);

plot(EELS.energy_loss_axis,A(:,1),'LineWidth',1)
hold on
plot(EELS.energy_loss_axis,dilateS,'LineWidth',1)