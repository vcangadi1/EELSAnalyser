clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 0.2s 0.3eV 0offset' )
EELS_spectrum = si_struct.image_data(8,4,:);
EELS_spectrum = reshape(EELS_spectrum,1,1024);

%EELS = zeros(size(EELS_spectrum));
%EELS(131:1024) = EELS_spectrum(131:1024);
%EELS = [EELS(131:1024) EELS(1:130)];


x = 1:1024;
y = log(EELS_spectrum);
p1 = polyfit(x,y,100);
f1 = polyval(p1,x);

res = exp(polyval(p1,x))-y;

plot(x,exp(y),'.k'), hold on, plot(x,exp(f1),'b.'), grid on;