clc
%%
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
Z = EELS_sum_spectrum(EELS);
llow = EELS.energy_loss_axis';
[llow,Z] = calibrate_zero_loss_peak(llow,Z);

dslow = mat2dataset([EELS.energy_loss_axis',Z/sum(Z)]);
export(dslow,'file','CoreGen.low','WriteVarNames',false);

load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
S = EELS_sum_spectrum(EELS);
lcor = EELS.energy_loss_axis';

As = S-feval(Power_law(lcor(400:472),S(400:472)),lcor);
As(1:400) = 0;
As = feval(Spline((1:1024)',As),(1:1024)');
As(As<0) = 0;

Ga = S-feval(Power_law(lcor(150:250),S(150:250)),lcor)-As;
Ga(1:250) = 0;
Ga = feval(Spline((1:1024)',Ga),(1:1024)');
Ga(Ga<0) = 0;

dscor = mat2dataset([EELS.energy_loss_axis',Ga]);
export(dscor,'file','CoreGen.cor','WriteVarNames',false);

[Gassd,Gapsd] = Frat('CoreGen.low',fwhm(llow,Z),'CoreGen.cor');

dscor = mat2dataset([EELS.energy_loss_axis',As]);
export(dscor,'file','CoreGen.cor','WriteVarNames',false);

[Asssd,Aspsd] = Frat('CoreGen.low',fwhm(llow,Z),'CoreGen.cor');

%% Lucy- Richardson Fourier Ratio deconvolution
[Zn,llow] = shift_zlp(Z,llow);
%c = conv(Zn/sum(Zn),ssd(1:1024,2));
Gassd_lucy = deconvlucy([Ga;flipud(Ga)],ifftshift(Zn/sum(Zn)));
Asssd_lucy = deconvlucy([As;flipud(As)],ifftshift(Zn/sum(Zn)));
%plot(c)
figure;
hold on
plotEELS(lcor,Ga)
plot(Gassd_lucy)
plotEELS(lcor,Gassd(1:1024,2))
legend('Ga','Gassd','Frat-ssd');
hold off

figure;
hold on
plotEELS(lcor,As)
plot(Asssd_lucy)
plotEELS(lcor,Asssd(1:1024,2))
legend('As','Asssd','Frat-ssd');
hold off
