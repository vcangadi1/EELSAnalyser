clc
close all
%clear all
%%

EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);

[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-0.7),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-13),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);
e_loss = EELS.calibrated_energy_loss_axis(:,:,minidx:maxidx);

SImage = medfilt1(SImage,20,[],3,'truncate');

%% Spline function

l = @(ii,jj) squeeze(e_loss(ii,jj,:));
S = @(ii,jj) squeeze(SImage(ii,jj,:));

tic;
for ii = EELS.SI_x:-1:1,
    for jj = EELS.SI_y:-1:1,
        Sm(ii,jj,:) = feval(Spline(l(ii,jj),S(ii,jj),0.95),l(ii,jj));
    end
end
toc;

%%

tic;
for ii = EELS.SI_x:-1:1,
    for jj = EELS.SI_y:-1:1,
        e = l(ii,jj);
        [~,miidx] = min(abs(e-0.7));
        [~,maidx] = min(abs(e-4));
        Eg_map(ii,jj) = e(gradient(squeeze(Sm(ii,jj,miidx:maidx)))==max(gradient(squeeze(Sm(ii,jj,miidx:maidx)))));
    end
end
toc;

%% Segment image
I = spectrum_image(EELS);

[BW,maskedImage] = segmentImage(I);

Eg_map = Eg_map.*imcomplement(BW);

plotEELS(Eg_map,'map')
