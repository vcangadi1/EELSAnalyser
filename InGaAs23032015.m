clc

si_struct = DM3Import( 'C:\Users\elp13va.VIE\Dropbox\MATLAB\InGaAs_Vn1061_230315\EELS Spectrum Image 2 Scan 69x2 pixels15.3nm 5s' );
EELS_spectrum = si_struct.image_data(1,15,:);
D = si_struct.zaxis.scale;
N = size(si_struct.image_data,3);
EELS_spectrum = reshape(EELS_spectrum,1,N).';
si_struct.EELS_spectrum = (EELS_spectrum);

delta = 20;
si_struct.sensitivity = delta;

x = ((1:1024)-100)*D+480;

edge = findedges_InGaAs_23032015(si_struct);

disp((edge+380).');


figure;
plot(x,smooth(si_struct.EELS_spectrum,15),'LineWidth',2)
hold on

[powerlaw, gof] = powerlaw_InGaAs(x(843:943), EELS_spectrum(843:943));
[fitresult, gof] = smoothspline(x(1:943).', EELS_spectrum(1:943));

peelsfit = powerlaw(x);
seelsfit(1:942) = fitresult(x(1:942));

As = zeros(1024,1);
As(1:942) = smooth(EELS_spectrum(1:942),15)-seelsfit(1:942);
As(943:1024)= smooth(si_struct.EELS_spectrum(943:1024)-peelsfit(943:1024),15);


plot(x(843:1024),peelsfit(843:1024),'LineWidth',2);
plot(x,As,'LineWidth',2);



[powerlaw, gof] = powerlaw_InGaAs(x(420:730), EELS_spectrum(420:730));

peelsfit = powerlaw(x);

As(1:942) = As(1:942)-As(1:942);

plot(x,peelsfit,'LineWidth',2);
plot(x(420:1024),smooth(si_struct.EELS_spectrum(420:1024)-peelsfit(420:1024),15) - As(420:1024),'LineWidth',2);





grid on;