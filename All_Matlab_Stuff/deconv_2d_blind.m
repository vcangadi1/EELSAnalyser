clc

it = 50;

%EELS = readEELSdata('C:\Users\elp13va.VIE\Desktop\EELS data\GaAs100_Q4_EELStest_130705\Pos1_20muCA\EELS_0.6mm_0.1s.dm3');
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/Pos1_20muCA/EELS_0.6mm_0.1s.dm3');

PSF = fspecial('gaussian',[200 1024],20);

J = deconvblind(EELS.Image,PSF,it);

S = sum(J);
l = (1:EELS.Image_y)'*0.05024;
l = calibrate_zero_loss_peak(l,S);

[~,minidx] = min(abs(l-0.5));
[~,maxidx] = min(abs(l-0.9546));
xl = l(minidx:maxidx);
yl = S(minidx:maxidx);
zl = feval(fit(xl,yl','a*exp(b*x)+c*exp(d*x)','StartPoint', [102440,-7.4722,-1.1220e+05,-17.1299],'Upper',[inf,0,inf,0]),l);

clear res
%res = S-zl;
%res(res<0)=0;
plotEELS(l,zl)

plotEELS(l,S)
ylim([-1000,3E5])