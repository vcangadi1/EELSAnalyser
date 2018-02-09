clc
close all
%clear all
%%

EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);

%% Find minimum point between 0.7eV to 13eV
[~,lminidx] = min(abs(EELS.calibrated_energy_loss_axis-0.7),[],3);
[~,lmaxidx] = min(abs(EELS.calibrated_energy_loss_axis-13),[],3);

SImage = EELS.SImage(:,:,lminidx:lmaxidx);
SImage = medfilt1(SImage,20,[],3,'truncate');
EELS.SImage(:,:,lminidx:lmaxidx) = SImage;

[~,minp] = min(abs(SImage),[],3);
%minp = lminidx + minp;

%% Subtract offset value from the spectrum
Offset = zeros(EELS.SI_x,EELS.SI_y);
tic;
for ii = 1:EELS.SI_x,
    Offset(ii,:) = arrayfun(@(jj) squeeze(SImage(ii,jj,minp(ii,jj))), (1:EELS.SI_y)');
end
toc;

EELS.SImage = EELS.SImage - repmat(Offset,1,1,EELS.SI_z);
%%



for ii = EELS.SI_x:-1:1,
    for jj = EELS.SI_y:-1:1,
        fprintf('Processing = %d X %d%\t',ii,jj);
        l = squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
        Sp = squeeze(EELS.SImage(ii,jj,:));
        
        [~,minidx] = min(abs(l-1));
        [~,maxidx] = min(abs(l-2));
        
        rng = maxidx-minidx;
        
        [~,maxidx] = min(abs(l-5));
        
        c = 1;
        for kk = minidx:maxidx-rng,
            fun = 300*(l(minidx:kk+rng)-l(kk)).^0.5;
            Spect = Sp(minidx:kk+rng);
            R2(c) = R_square(Spect,fun);
            Eg(c) = l(kk);
            c = c+1;
        end
        %R2(R2<0) = 0;
        bg(ii,jj) = Eg(R2==max(R2(:)));
        if R2(R2==max(R2(:)))<0
            Rsq(ii,jj) = 0;
        else
            Rsq(ii,jj) = R2(R2==max(R2(:)));
        end
        R2(R2<0) = 0;
        fprintf('Processed = %d X %d\n',ii,jj);
    end
end
