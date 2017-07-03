clc
clear all

EELS = readEELSdata('EELS Spectrum Image1-thickness-map.dm3');

EELS = calibrate_zero_loss_peak(EELS);
nlloss = zeros(size(EELS.SImage));
for ii = EELS.SI_x:-1:1
    for jj = EELS.SI_y:-1:1
        l = squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
        Z = EELS.S(ii,jj);
        nlloss(ii,jj,:) = low_loss(l,plasmon_peak(l,Z),tbylambda(l,Z),fwhm(l,Z),plasmon_width(l,Z));
    end
end

% Scale zero loss peak height
lloss = nlloss.*repmat(max(EELS.SImage,[],3),1,1,EELS.SI_z)./repmat(max(nlloss,[],3),1,1,EELS.SI_z);

%
E = EELS;
E.SImage = lloss;
res = EELS.SImage - E.SImage;