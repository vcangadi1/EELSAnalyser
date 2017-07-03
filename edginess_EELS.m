clc
close all


EELS = readEELSdata;
A = EELSmatrix(EELS.SImage);

w = 3;
S = A(:,1);

h = hankel(S);
h1 = h(:,1:w);

sumv = 2*h1(:,2)-h1(:,1)-h1(:,3);
