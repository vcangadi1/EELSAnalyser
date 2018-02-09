clc
close all
%%
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
%EELS = readEELSdata;
%% Load gaussian function at 0eV
llow = EELS.energy_loss_axis';

%Z = normpdf(llow,0,2)+normpdf(llow,100*0.2,2)*0.2+normpdf(llow,200*0.2,2)*0.04;
Z = EELS_sum_spectrum(EELS);
%Z = EELS.spectrum;

%% Calibrate zero-loss peak
[llow,Z] = calibrate_zero_loss_peak(llow,Z);

%% Create spectrum and convolve with zero_loss_peak
lcor = llow+100;
E = create_ionization_edge(200 , 1E3, 0.5, lcor);
% plural scattering
pE = plural_scattering(E,Z);

%% Lucy-Richardson
Zn = shift_zlp(Z,llow);
R = deconvlucy(pE,ifftshift(Zn/sum(Zn)));

%% Fourier-Ratio deconv (Egerton)

dslow = mat2dataset([llow,Z/sum(Z)]);
export(dslow,'file','CoreGen.low','WriteVarNames',false);
dscor = mat2dataset([lcor,pE(1:1024)]);
export(dscor,'file','CoreGen.cor','WriteVarNames',false);

[Rssd,Rpsd] = Frat([llow,Z/sum(Z)],fwhm(llow,Z),[lcor,pE(1:1024)]);

%% Fourier-Ratio deconv (Veer)
rE = fourier_ratio([llow,Z],fwhm(llow,Z),[lcor,pE]);

%%
figure;
hold on
plotEELS(lcor,E)
plotEELS(lcor,pE(1:1024))
plotEELS(lcor,R(1:1024))
plotEELS(lcor,(Rssd(1:1024,2)))
plotEELS(lcor,rE)

legend('Original edge','plural','lucy-richardson','Frat-egerton','Fourier-ratio');
