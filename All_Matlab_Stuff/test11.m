clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );
EELS_spectrum = si_struct.image_data(1,1,:);
D = si_struct.zaxis.scale;
N = size(si_struct.image_data,3);
EELS_spectrum = reshape(EELS_spectrum,1,N).';

yaxis = smooth(EELS_spectrum,15);
%xaxis = ((1:N).*D -56+78).';
xaxis = (1:1:N).';

curvef = zeros(size(xaxis));
cf1 = zeros(size(xaxis));
cf2 = zeros(size(xaxis));
cf3 = zeros(size(xaxis));
cf4 = zeros(size(xaxis));

edge1 = 154;
edge2 = 519;

[fitresult, gof] = smoothspline((1:edge1).', EELS_spectrum(1:edge1));
cf1(1:edge1) = fitresult(xaxis(1:edge1));


[fitresult, gof] = exp1((edge1-30:edge1).', yaxis(edge1-30:edge1));
cf2(1:N) = fitresult(xaxis(1:N));

[fitresult, gof] = exp1((edge2-30:edge2).', EELS_spectrum(edge2-30:edge2));
cf3(edge2:N) = fitresult(xaxis(edge2:N));

[fitresult, gof] = exp1([edge1 edge2].', [EELS_spectrum(edge1) yaxis(edge2)]);
cf4(edge1:edge2) = fitresult(xaxis(edge1:edge2));

for i=1:N,
    curvef(i) = max([cf1(i) cf2(i) cf3(i) cf4(i)]);
end

core = EELS_spectrum-curvef;

figure(1);
grid on
hold on
plot(xaxis,EELS_spectrum,'-b','LineWidth',3)
plot(xaxis,curvef,':r','LineWidth',3)
plot(xaxis,core,'k','LineWidth',3)
legend('EELS','background','core')
%plot(xaxis(cf1>0),cf1(cf1>0),'r','LineWidth',3)
%plot(xaxis(cf2>0),cf2(cf2>0),'r','LineWidth',3)
%plot(xaxis(cf3>0),cf3(cf3>0),'r','LineWidth',3)