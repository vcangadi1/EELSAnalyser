clc

it = 10;

EELS = readEELSdata('C:\Users\elp13va.VIE\Desktop\EELS data\GaAs100_Q4_EELStest_130705\Pos1_20muCA\EELS_0.6mm_0.1s.dm3');
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/Pos1_20muCA/EELS_0.6mm_0.1s.dm3');
l = (1:EELS.Image_y)'*0.05024;
S = sum(EELS.Image)';
l = calibrate_zero_loss_peak(l,S);

[W0,E0,A0,G] = zero_loss_fit(l,S);

dS = deconvblind(S,A0*G(l,E0,W0),it);

l = calibrate_zero_loss_peak(l,dS,'gauss');

[~,minidx] = min(abs(l-0.3));
[~,maxidx] = min(abs(l-0.43));
xl = l(minidx:maxidx);
yl = dS(minidx:maxidx);
zl = feval(fit(xl,yl,'a*exp(b*x)+c*exp(d*x)','StartPoint', [102440,-7.4722,-1.1220e+05,-17.1299],'Upper',[inf,0,inf,0]),l);

res = dS-zl;
res(res<0)=0;
plotEELS(l,res)
ylim([-1000,1000])
xlim([0,10])