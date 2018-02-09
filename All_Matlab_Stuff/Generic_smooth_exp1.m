%%  This code is for the part by part fit of the spectrum.
%   1. First fit for the zero-loss peak from 0eV - 90eV
%   2. Fit for the rest of the spectrum from 90eV - NeV

fprintf(1,'\n---------------Generic Exponential Curve fit--------------\n\n');

%   Read spectrum from input file
si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' )

%   Read length of the Spectrum
N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);

%   Read Dispersion of the spectrum
D = si_struct.zaxis.scale;
fprintf('\nDispersion : %.2f\n',D);

%   Read the actual Origin of the Spectrum
Origin = si_struct.zaxis.origin;
fprintf('\nOrigin : %d\n',Origin);

%   Read the EELS Spectrum from meta data  
EELS_spectrum = si_struct.image_data(8,4,:);                                         %Reading Spectrum of (8,4) pixel
EELS_spectrum = reshape(EELS_spectrum,1,N);

%   Select the data range of interests
n(1) = input('Enter the start point : ');
n(2) = input('Enter the end point : ');
EELS = EELS_spectrum(n(1):n(2));
X = (n(1):1:n(2)).';

%   Smooth the spectrum
sEELS = smooth(EELS);

%   Normalize EELS from 0 - 1, Dividing by max value of EELS
%   Normalize X from 0 - 1, Dividing by N
maxEELS = max(EELS_spectrum);
nEELS = (sEELS)./maxEELS;
nX = X./N;

%plot(X,nEELS,'.')

%%  Call Exponential Curve fit funtion
[fitresult, gof] = exp1(nX, nEELS);

%%  Calculate the Residual Core-Loss spectrum
nY = fitresult(nX(1:end));
cfilt = (nEELS(1:end) - nY(1:end))>0;
Core = nEELS(cfilt) - nY(cfilt);

%%  Plot the figures
figure;
plot(nX*N,nY*maxEELS,'r','LineWidth',2)
hold on
plot(nX*N,nEELS*maxEELS,'--','LineWidth',2)
plot(nX(cfilt)*N,Core*maxEELS,'-g','LineWidth',2)
xlabel('Energy (eV)');
ylabel('CCD counts');
title('EELS background subtraction from single exponential function');
legend('Background fit','Spectrum','Core-Loss');
axis([0 N 0 maxEELS]);