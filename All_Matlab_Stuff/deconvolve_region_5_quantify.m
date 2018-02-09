clc
close all
%% Low-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')

Z = EELS_sum_spectrum(EELS);
llow = calibrate_zero_loss_peak(EELS.energy_loss_axis,Z)';

figure;
plotEELS(llow,Z)
% Normalize area of zlp to unity
export(mat2dataset([llow,Z/sum(Z)]),'file','CoreGen.low','WriteVarNames',false);

%% 950eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

S950 = EELS_sum_spectrum(EELS);
l950 = EELS.energy_loss_axis';

Ga = S950-feval(Power_law(l950(150:250),S950(150:250)),l950);
Ga(1:250) = 0;

export(mat2dataset([l950,Ga]),'file','CoreGen.cor','WriteVarNames',false);

Gassd = Frat('CoreGen.low',2.6,'CoreGen.cor');

figure;
plotEELS(l950,S950)
hold on
plot(l950,Ga)
plot(l950,Gassd(1:1024,2))

qGa = (sum(Gassd(265:465,2))/2)/Sigmal3(31,201,198,15);
%Sigpar(31,201,'L',198,15);

%% 250eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')

S250 = EELS_sum_spectrum(EELS);
l250 = EELS.energy_loss_axis';

In = S250-feval(Power_law(l250(400:500),S250(400:500)),l250);
In(1:400) = 0;

export(mat2dataset([l250,In]),'file','CoreGen.cor','WriteVarNames',false);

Inssd = Frat('CoreGen.low',2.6,'CoreGen.cor');

figure;
plotEELS(l250,S250)
hold on
plot(l250,In)
plot(l250,Inssd(1:1024,2))

qIn = (sum(Inssd(502:664,2))/0.5)/(Sigpar(49,82,'M45',198,15)/10^-24);
fprintf('In : %f\n',qIn)

%% 80eV offset core-loss spectrum
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')

S80 = EELS_sum_spectrum(EELS);
l80 = EELS.energy_loss_axis';

% P-L3
P = S80-feval(Power_law(l80(575:620),S80(575:620)),l80);
P(1:575) = 0;

export(mat2dataset([l80,P]),'file','CoreGen.cor','WriteVarNames',false);

Pssd = Frat('CoreGen.low',2.6,'CoreGen.cor');

qP = (sum(Pssd(650:end,2))/0.5)/Sigmal3(15,37.4,198,15);
%Sigpar(15,37.4,'L',198,15);

% Al-L1
Al = S80-feval(Power_law(l80(400:480),S80(400:480)),l80)-P;
Al(1:400) = 0;

export(mat2dataset([l80,Al]),'file','CoreGen.cor','WriteVarNames',false);

Alssd = Frat('CoreGen.low',2.6,'CoreGen.cor');

qAl = (sum(Alssd(480:end,2))/0.5)/Sigmal3(13,54.4,198,15);
%Sigpar(13,54.4,'L',198,15);

figure;
plotEELS(l80,S80)
hold on
plot(l80,P)
plot(l80,squeeze(Pssd(1:1024,2)))
plot(l80,Al)
plot(l80,squeeze(Alssd(1:1024,2)))

%% Quantification of In, Ga & P
q = (qIn+qGa+qP+qAl)/100;
fprintf('In : %f\n',qIn/q)
fprintf('Ga : %f\n',qGa/q)
fprintf('P : %f\n',qP/q)
fprintf('Al : %f\n',qAl/q)