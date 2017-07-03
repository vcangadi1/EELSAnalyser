clc
%clear all

it = 50;

%% Load PSF

%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/ZLP0.1s_0.05disp_20eVdriftTubeOffsetagain.dm3');
EELS = readEELSdata('C:\Users\elp13va.VIE\Desktop\EELS data\GaAs100_Q4_EELStest_130705\ZLP0.1s_0.05disp_20eVdriftTubeOffsetagain.dm3');

PSF = EELS.Image(71:370,101:end)' - 2*min(EELS.Image(:));

PSF = PSF./sum(PSF(:));

figure(1)
plotEELS(PSF,'map')

%% Load 2D spectrum

%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/Pos1_20muCA/EELS_0.6mm_0.1s.dm3');
EELS = readEELSdata('C:\Users\elp13va.VIE\Desktop\EELS data\GaAs100_Q4_EELStest_130705\Pos1_20muCA\EELS_0.6mm_0.1s.dm3');

l = (1:EELS.Image_y)'*0.05024;
S = sum(EELS.Image)';
l = calibrate_zero_loss_peak(l,S,'gauss');

%% Richardson-Lucy deconvolution

J = deconvlucy(edgetaper(EELS.Image,fspecial('gaussian',40,10)), PSF, it);

figure(2)
plotEELS(l,S)
plotEELS(calibrate_zero_loss_peak(l,sum(J)','gauss'),sum(J)')

%% Blind deconvolution

J = deconvblind(edgetaper(EELS.Image,fspecial('gaussian',40,10)), PSF, it);

figure(3)
plotEELS(l,S)
plotEELS(calibrate_zero_loss_peak(l,sum(J)','gauss'),sum(J)')