clc
EELS = readEELSdata;
I = EELS.Image;
PSF = fspecial('gaussian',10,10);
Blurred = imfilter(I,PSF);
WT = zeros(size(I));
WT(5:end-4,5:end-4) = 1;
INITPSF = ones(size(PSF));
[J,P] = deconvblind(Blurred,INITPSF,20,[],WT);

figure
subplot(221);plotEELS(Blurred,'map');
title('A = Image (*) PSF');
subplot(222);plotEELS(PSF,'map');
title('True PSF');
subplot(223);plotEELS(J,'map');
title('Deblurred Image');
subplot(224);plotEELS(P,'map');
title('Recovered PSF');