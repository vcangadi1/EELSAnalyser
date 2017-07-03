clc
clear all
close all
%% Load low loss
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
Z = EELS_sum_spectrum(EELS);
llow = EELS.energy_loss_axis';
[llow,Z] = calibrate_zero_loss_peak(llow,Z);
[Zn,llown] = shift_zlp(Z,llow);
%plot(llow,Zn)
l = llow+100;
%% Create an edge
edge_at = 200;
E = create_ionization_edge(edge_at,1E4,0.01,llow);

% Convolve with low loss to make plural scattering.
cE = conv(Zn/sum(Zn),E);
pE = cE(1:1024);
fprintf('plural/single = %6.2f%% \n',sum(pE)/sum(E)*100);
%plot(1:length(cE),cE)
%hold on
%plot(1:length(E),E)
%grid on
%hold off


%% Add background
B = feval(Power_law([l(edge_at) l(end)],[3E4 1E4]),l');

S = B+pE;%+randn(size(l))*100; % S is artificially generated edge


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Subtraction

pR = S-feval(Power_law(l(edge_at-100:edge_at),S(edge_at-100:edge_at)),l);
pR(1:edge_at) = 0;
pR(pR<0)=0;
%pR = feval(Spline(l,pR),l);

%% Lucy-Richardson deconvolution

R = deconvlucy([pR;flipud(pR)],ifftshift(Zn/sum(Zn)));
%R = deconvlucy(R,ifftshift(Zn/sum(Zn)));
%R = deconvlucy(R,ifftshift(Zn/sum(Zn)));

fprintf('Lucy-Ruchardson : deconv/original edge = %6.2f%% \n',sum(R(1:1024))/sum(E)*100);

%% Fourier Ratio deconvolution

dslow = mat2dataset([llow,Z/sum(Z)]);
export(dslow,'file','CoreGen.low','WriteVarNames',false);
dscor = mat2dataset([l,pR]);
export(dscor,'file','CoreGen.cor','WriteVarNames',false);

[Rssd,Rpsd] = Frat('CoreGen.low',fwhm(llow,Z),'CoreGen.cor',[cE;cE(end)]');
fprintf('Fourier-Ratio : deconv/original edge = %6.2f%% \n',sum(Rssd(1:1024,2))/sum(E)*100);
%dscor = mat2dataset([l,Rssd(1:1024,2)]);
%export(dscor,'file','CoreGen.cor','WriteVarNames',false);
%[Rssd,Rpsd] = Frat('CoreGen.low',fwhm(llow,Z),'CoreGen.cor');

%fprintf('Fourier-Ratio : deconv/original edge = %6.2f%% \n',sum(Rssd(1:1024,2))/sum(E)*100);

%% figure;
figure
hold on
plotEELS(l,pR)
plotEELS(l,R(1:1024))
plotEELS(l,Rssd(1:1024,2))
plotEELS(l,E)
hold off
legend1 = legend('PSD','Lucy-Richardson','Fourier-Ratio','Original edge');
set(legend1,'FontWeight','bold','FontSize',10,'Location','best');
legend('boxoff');
grid on