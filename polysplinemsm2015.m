clc

si_struct = DM3Import( 'C:\Users\elp13va.VIE\Dropbox\MATLAB\InGaAs_Vn1061_230315\EELS Spectrum Image3 InP+InGaAsbuffer 2.3nmSpot 667x2 no offset 0.05disp' );
EELS_spectrum = si_struct.image_data(1,1,:);
EELS_spectrum = reshape(EELS_spectrum,1024,1);

figure(1)
plot((1:1024)*0.05-21.6,EELS_spectrum);

x = EELS_spectrum(600:1000);

[pmsm, gof] = polymsm2015(x);
[smsm, gof] = splinemsm2015(x);


