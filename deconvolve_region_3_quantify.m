clc
close all
%% Low-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')

Z = EELS_sum_spectrum(EELS);
llow = calibrate_zero_loss_peak(EELS.energy_loss_axis,Z)';
FWHM = fwhm(llow,Z);

%figure;
%plotEELS(llow,Z)
% Normalize area of zlp to unity
export(mat2dataset([llow,Z/sum(Z)]),'file','CoreGen.low','WriteVarNames',false); 

%% 950eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

S950 = EELS_sum_spectrum(EELS);
l950 = EELS.energy_loss_axis';

As = S950-feval(Exponential_fit(l950(400:472),S950(400:472)),l950);
As(As<0) = 0;
As(1:372) = 0;

%plotEELS(l950,S950)
%hold on
%plotEELS(l950,As)

export(mat2dataset([l950,As]),'file','CoreGen.cor','WriteVarNames',false);

Asssd = Frat('CoreGen.low',FWHM,'CoreGen.cor');

Ga = S950-feval(Power_law(l950(150:250),S950(150:250)),l950)-As;
Ga(1:250) = 0;

export(mat2dataset([l950,Ga]),'file','CoreGen.cor','WriteVarNames',false);

Gassd = Frat('CoreGen.low',FWHM,'CoreGen.cor');

%figure;
%plotEELS(l950,S950)
%hold on
%plot(l950,Ga)
%plot(l950,As)
%plot(l950,Gassd(1:1024,2))
%plot(l950,Asssd(1:1024,2))

qGa = (sum(Gassd(265:465,2))/2)/Sigmal3(31,201,198,15);
qAs = (sum(Asssd(476:676,2))/2)/Sigmal3(33,201,198,15);
%qGa = sum(Gassd(265:465,2))/Sigpar(31,201,'L',198,15);
%qAs = sum(Gassd(476:676,2))/Sigpar(33,201,'L',198,15);

%% 250eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')

S250 = EELS_sum_spectrum(EELS);
l250 = EELS.energy_loss_axis';

%% 80eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')

S80 = EELS_sum_spectrum(EELS);
l80 = EELS.energy_loss_axis';

% P-L3
P = S80-feval(Power_law(l80(575:620),S80(575:620)),l80);
%P = S80-feval(Exponential_fit(l80(515:575),S80(515:575)),l80);
P(1:575) = 0;

export(mat2dataset([l80,P]),'file','CoreGen.cor','WriteVarNames',false);

Pssd = Frat('CoreGen.low',2.6,'CoreGen.cor');

qP = (sum(Pssd(650:end,2))/0.5)/Sigmal3(15,37.4,198,15);
%Sigpar(15,37.4,'L',198,15);

% Si-L3
Si = S80-feval(Power_law(l80(200:280),S80(200:280)),l80)-P;
Si(1:200) = 0;

export(mat2dataset([l80,Si]),'file','CoreGen.cor','WriteVarNames',false);

Sissd = Frat('CoreGen.low',2.6,'CoreGen.cor');

qSi = (sum(Sissd(280:330,2))/0.5)/Sigmal3(14,5,198,15);
%Sigpar(14,30,'L',198,15);

%figure;
%plotEELS(l80,S80)
%hold on
%plot(l80,P)
%plot(l80,squeeze(Pssd(1:1024,2)))
%plot(l80,Si)
%plot(l80,squeeze(Sissd(1:1024,2)))

%% Quantification of In, Ga & P
q = (qGa+qAs+qP+qSi)/100;
fprintf('Ga : %f\n',qGa/q)
fprintf('As : %f\n',qAs/q)
fprintf('P : %f\n',qP/q)
fprintf('Si : %f\n',qSi/q)

%%
%close all
Zn = shift_zlp(Z);
Ga_lucy = deconvlucy([Ga;flipud(Ga)],ifftshift(Zn/sum(Zn)));
As_lucy = deconvlucy([As;flipud(As)],ifftshift(Zn/sum(Zn)));
P_lucy = deconvlucy([P;flipud(P)],ifftshift(Zn/sum(Zn)));
Si_lucy = deconvlucy([Si;flipud(Si)],ifftshift(Zn/sum(Zn)));

qGa_lucy = (sum(Ga_lucy(265:465))/2)/Sigmal3(31,201,198,15);
qAs_lucy = (sum(As_lucy(476:676))/2)/Sigmal3(33,201,198,15);
qP_lucy = (sum(P_lucy(650:750))/0.5)/Sigmal3(15,10,198,15);
qSi_lucy = (sum(Si_lucy(280:330))/0.5)/Sigmal3(14,5,198,15);

%% Quantification of In, Ga & P
q_lucy = (qGa_lucy+qAs_lucy+qP_lucy+qSi_lucy)/100;
fprintf('Ga : %f\n',qGa_lucy/q_lucy)
fprintf('As : %f\n',qAs_lucy/q_lucy)
fprintf('P : %f\n',qP_lucy/q_lucy)
fprintf('Si : %f\n',qSi_lucy/q_lucy)