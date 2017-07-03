clc
clear all
close all

a = 1;
b = 1;
si_struct = DM3Import( 'Core-loss Atlas\Al(0-3920eV)' );
temp = si_struct.spectra_data{1,1}.';
figure;
plot(temp,'LineWidth',2);
strt = input('\nSpectrum starting point = ');
si_struct.strt = strt;
sensitivity = input('\nEdge detection sensitivity = ');
si_struct.sensitivity = sensitivity;

si_struct.EELS_spectrum = temp(strt:end);
EELS_spectrum = si_struct.EELS_spectrum;
%D = si_struct.zaxis.scale;
si_struct.D = (3920-0)/length(EELS_spectrum);
D = si_struct.D;
%N = size(si_struct.image_data,3);
si_struct.N = length(EELS_spectrum);
N = si_struct.N;
%origin = si_struct.zaxis.origin;
si_struct.origin = -1;
origin = si_struct.origin;
si_struct.offset = 0;
offset = si_struct.offset;
EELS_spectrum = reshape(EELS_spectrum,1,N).';

yaxis = smooth(EELS_spectrum,15);
%xaxis = ((1:N).*D +origin+offset).';
xaxis = (1:1:N).';

edge = findedges_CaO_0350_1360(si_struct);
fprintf('Detected edges : ');
disp(edge.');

k = 1;
minE = EELS_spectrum(edge(1));
for i=1:length(edge),
    if(EELS_spectrum(edge(i))<=minE)
        E(k) = edge(i);
        minE = EELS_spectrum(edge(i));
        k = k+1;
    end
end

edge1 = E(1);
edge2 = E(2);

fprintf('Edges considered for background subtraction : ')
disp(E);

curvef = zeros(size(xaxis));
cf1 = zeros(size(xaxis));
cf2 = zeros(size(xaxis));
cf3 = zeros(size(xaxis));
%cf4 = zeros(size(xaxis));

[fitresult, gof] = smoothspline((1:edge1).', EELS_spectrum(1:edge1));
cf1(1:edge1) = fitresult(xaxis(1:edge1));

[fitresult, gof] = exp1((edge1-30:edge1).', yaxis(edge1-30:edge1));
cf2(1:N) = fitresult(xaxis(1:N));

[fitresult, gof] = exp1((edge2-30:edge2).', EELS_spectrum(edge2-30:edge2));
cf3(edge2:N) = fitresult(xaxis(edge2:N));

%[fitresult, gof] = exp1([edge1 edge2].', [EELS_spectrum(edge1) yaxis(edge2)]);
%cf3(edge1:edge2) = fitresult(xaxis(edge1:edge2));

[fitresult, gof] = smoothspline((1:edge2).', EELS_spectrum(1:edge2));
cf4(1:edge2) = fitresult(xaxis(1:edge2));

for i=1:N,
    curvef(i) = max([cf1(i) cf2(i) cf3(i)]);
end
core = EELS_spectrum-curvef;

%figure (1);
subplot(3,1,1)
grid on
hold on
plot(((1:N).*D +origin+offset).',EELS_spectrum,'-b','LineWidth',2)
plot(((1:N).*D +origin+offset).',curvef,':r','LineWidth',2)
plot(((1:N).*D +origin+offset).',core,'k','LineWidth',2)
legend('EELS','background','core')
%plot(xaxis(cf1>0),cf1(cf1>0),'r','LineWidth',3)
%plot(xaxis(cf2>0),cf2(cf2>0),'r','LineWidth',3)
%plot(xaxis(cf3>0),cf3(cf3>0),'r','LineWidth',3)

bg2 = zeros(size(EELS_spectrum));
bg2 = [cf4(1:edge2).'; cf3(edge2+1:N)];
curve2 = EELS_spectrum-bg2;
subplot(3,1,2)
plot(((1:N).*D +origin+offset).',curve2,'k','LineWidth',2)
grid on

bg2 = [EELS_spectrum(1:edge2); cf3(edge2+1:N)];
curve2 = EELS_spectrum-bg2;
bg1 = zeros(size(EELS_spectrum));
bg1 = [cf1(1:edge1); cf2(edge1+1:N)];
curve1 = EELS_spectrum-bg1-curve2;
subplot(3,1,3)
plot(((1:N).*D +origin+offset).',curve1,'r','LineWidth',2)
grid on