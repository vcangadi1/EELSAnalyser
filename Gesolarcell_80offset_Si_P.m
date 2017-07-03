clc
close all

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')

I = max(EELS.SImage, [], 3);
I(I<1000) = 0;
I(I>1000) = 1;

EELS.SImage = EELS.SImage.*repmat(I,[1,1,EELS.SI_z]);

h = plotEELS(EELS);
Si_L3 = zeros(size(EELS.SImage));
P_L3 = zeros(size(EELS.SImage));
Al_L1 = zeros(size(EELS.SImage));
SImage = zeros(size(EELS.SImage));

for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        SImage(i,j,:) = medfilt1(squeeze(EELS.SImage(i,j,:)),5,'truncate');
        SImage(i,j,:) = medfilt1(squeeze(SImage(i,j,:)),5,'truncate');
        E = squeeze(SImage(i,j,:))';
        fitresult = Power_law(EELS.energy_loss_axis(130:270),E(130:270));
        Si_L3(i,j,:) = [squeeze(EELS.SImage(i,j,1:129));fitresult(EELS.energy_loss_axis(130:end))];
        fitresult1 = Power_law(EELS.energy_loss_axis(350:450),E(350:450));
        Al_L1(i,j,:) = [squeeze(EELS.SImage(i,j,1:349));fitresult1(EELS.energy_loss_axis(350:end))];
        fitresult2 = Power_law(EELS.energy_loss_axis(350:450),E(350:450));
        P_L3(i,j,:) = [squeeze(EELS.SImage(i,j,1:649));fitresult1(EELS.energy_loss_axis(650:end))];
    end
end

figure;
% Silicon (L3) Map: delta = 15eV, 100eV - 115eV
Si = EELS.SImage - Si_L3;
Si_map = sum(Si(:,:,300:450),3);
subplot 131
imshow(uint64(Si_map),[0 max(Si_map(:))])
title('Silicon (L3) Map')

% Aluminium (L1) Map: delta = 15eV, 118eV - 133eV
Al = EELS.SImage - Al_L1;
Al_map = sum(Al(:,:,480:630),3);
subplot 132
imshow(uint64(Al_map),[0 max(Al_map(:))])
title('Aluminium (L1) Map')

% Phosphorus (L1) Map: delta = 15eV, 135eV - 150eV
P = EELS.SImage - P_L3;
P_map = sum(P(:,:,650:800),3);
subplot 133
imshow(uint64(P_map-Al_map),[0 max(P_map(:)-Al_map(:))])
title('Phosphorus (L1) Map');