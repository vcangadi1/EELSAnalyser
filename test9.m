clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );
EELS_spectrum = si_struct.image_data(1,1,:);
N = size(si_struct.image_data,3);
EELS_spectrum = reshape(EELS_spectrum,1,N).';
D = si_struct.zaxis.scale;
yaxis = smooth(EELS_spectrum,10);
xaxis = (1:1:N).';

for m=1:N-1,
    dy = yaxis(m+1) - yaxis(m);
    dx = xaxis(m+1) - xaxis(m);
    ang(m) = (atan(dy/dx).*180/pi);
end
ang(m+1) = ang(m);

xaxis = (1:N).*D -56+78;

%plot((1:N).*D -56+78,ang*20,'.r')
%hold on
%plot((1:N).*D -56+78,EELS_spectrum,'LineWidth',2)
%plot((1:N).*D -56+78,45*20,'LineWidth',3)
[haxes,hline1,hline2]=plotyy(xaxis,(EELS_spectrum),(1:N).*D -56+78,ang,'plot','plot')
set(hline2,'LineStyle','.','LineWidth',1,'Color','r');
ylabel(haxes(1),'Semilog Plot') % label left y-axis
ylabel(haxes(2),'Linear Plot') % label right y-axis
xlabel(haxes(2),'Time') % label x-axis
%# horizontal line
hy = graph2d.constantline(0, 'Color','k','LineWidth',2);
changedependvar(hy,'y');
%grid on