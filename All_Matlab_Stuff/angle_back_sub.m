clc
clear all
close all

p_x = 1;
p_y = 1;
[filename, pathname] = uigetfile({'.dm3'},'File Selector');
fullpathname = strcat(pathname,filename);
%fullpathname = 'Core-loss Atlas\Ag(0-0910eV)';
t = str2double(regexp(fullpathname,'(\d+)-(\d+)','tokens','once'));

si_struct = DM3Import(fullpathname);
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

si_struct.D = (t(2)-t(1))/length(EELS_spectrum);
D = si_struct.D;
%N = size(si_struct.image_data,3);
si_struct.N = length(EELS_spectrum);
N = si_struct.N;
%origin = si_struct.zaxis.origin;
figure;
si_struct.origin = -1;
origin = si_struct.origin;
si_struct.offset = t(1);
offset = si_struct.offset;
EELS_spectrum = reshape(EELS_spectrum,1,N).';

plot((1:N).*D +origin+offset,EELS_spectrum,'LineWidth',2);
yaxis = smooth(EELS_spectrum,15);
%xaxis = ((1:N).*D +origin+offset).';
xaxis = (1:1:N).';

edge = findedges_CaO_0350_1360(si_struct);
edge1 = edge(1);
%edge2 = edge(2);

fprintf('Detected edges : ');
disp(uint32(edge.'.*D +origin+offset));

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
%edge2 = E(2);

fprintf('Edges considered for background subtraction : ')
disp(uint32(E.*D +origin+offset));


curvef = zeros(size(xaxis));
cf1 = zeros(size(xaxis));
cf2 = zeros(size(xaxis));
cf3 = zeros(size(xaxis));
%cf4 = zeros(size(xaxis));

span = 30;
for i=1:length(E),
    [fitresult, gof] = smoothspline((1:E(i)).', EELS_spectrum(1:E(i)));
    cf1(1:E(i),i) = fitresult(xaxis(1:E(i)));
    while(E(i)-span<=0)
        span =span-1;
    end
    [fitresult, gof] = exp1((E(i)-span:E(i)).', yaxis(E(i)-span:E(i)));
    cf2(E(i):N,i) = fitresult(xaxis(E(i):N));
end


%[fitresult, gof] = exp1([edge1 edge2].', [EELS_spectrum(edge1) yaxis(edge2)]);
%cf3(edge1:edge2) = fitresult(xaxis(edge1:edge2));


for j = 1:length(E),
    for i=1:N,    
        curvef(i) = max([cf1(i,1) cf2(i,j)]);
    end
end
core = EELS_spectrum-reshape(curvef,N,1);


if(length(E)<2)
    figure;
    %subplot(3,1,1)
    grid on
    hold on
    plot(((1:N).*D +origin+offset).',EELS_spectrum,'-b','LineWidth',2)
    plot(((1:N).*D +origin+offset).',curvef,':r','LineWidth',2)
    plot(((1:N).*D +origin+offset).',core,'k','LineWidth',2)
    legend('EELS','background','core')
    %plot(xaxis(cf1>0),cf1(cf1>0),'r','LineWidth',3)
    %plot(xaxis(cf2>0),cf2(cf2>0),'r','LineWidth',3)
    %plot(xaxis(cf3>0),cf3(cf3>0),'r','LineWidth',3)
    
else
figure;
subplot(3,1,1)
grid on
hold on
plot(((1:N).*D +origin+offset).',EELS_spectrum,'-b','LineWidth',2)
%plot(((1:N).*D +origin+offset).',curvef,':r','LineWidth',2)
%plot(((1:N).*D +origin+offset).',core,'k','LineWidth',2)
legend('EELS')
%plot(xaxis(cf1>0),cf1(cf1>0),'r','LineWidth',3)
%plot(xaxis(cf2>0),cf2(cf2>0),'r','LineWidth',3)
%plot(xaxis(cf3>0),cf3(cf3>0),'r','LineWidth',3)

bg2 = zeros(size(EELS_spectrum));
bg2 = [cf1(1:E(2),2); cf2(E(2)+1:N,2)];
curve2 = EELS_spectrum-bg2;
subplot(3,1,2)
plot(((1:N).*D +origin+offset).',curve2,'k','LineWidth',2)
legend('Edge')
grid on

bg2 = [EELS_spectrum(1:E(2)); cf2(E(2)+1:N,2)];
curve2 = EELS_spectrum-bg2;
bg1 = zeros(size(EELS_spectrum));
bg1 = [cf1(1:edge1,1); cf2(edge1+1:N,1)];
curve1 = EELS_spectrum-bg1-curve2;
subplot(3,1,3)
plot(((1:N).*D +origin+offset).',curve1,'r','LineWidth',2)
legend('Edge')
grid on
end