clc
close all

%EELS = readEELSdata('Ge-basedSolarCell_24082015\.dm3');
%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

%I = max(EELS.SImage, [], 3);
%I(I<2000) = 0;
%I(I>2000) = 1;

%EELS.SImage = EELS.SImage.*repmat(I,[1,1,EELS.SI_z]);

plotEELS(EELS);
Cu_L23 = zeros(size(EELS.SImage));
Ga_L23 = zeros(size(EELS.SImage));
As_L23 = zeros(size(EELS.SImage));
SImage = zeros(size(EELS.SImage));

for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        SImage(i,j,:) = medfilt1(squeeze(EELS.SImage(i,j,:)),5);
        SImage(i,j,:) = medfilt1(squeeze(SImage(i,j,:)),5);
        E = squeeze(SImage(i,j,:))';
        fitresult = Power_law(EELS.energy_loss_axis(1:75),E(1:75));
        Cu_L23(i,j,:) = [squeeze(EELS.SImage(i,j,1:80));fitresult(EELS.energy_loss_axis(81:end))];
        fitresult1 = Power_law(EELS.energy_loss_axis(200:260),E(200:260));
        Ga_L23(i,j,:) = [squeeze(EELS.SImage(i,j,1:264));fitresult1(EELS.energy_loss_axis(265:end))];
        fitresult2 = Power_law(EELS.energy_loss_axis(400:470),E(400:470));
        As_L23(i,j,:) = [squeeze(EELS.SImage(i,j,1:472));fitresult2(EELS.energy_loss_axis(473:end))];
    end
end

% Copper (L23) Map: delta = 50eV, 931eV - 981eV
Cu = EELS.SImage - Cu_L23;
Cu_map = sum(Cu(:,:,81:131),3);
subplot 131
imshow(uint64(Cu_map),[0 max(Cu_map(:))])
title('Copper (L23) Map')

% Galium (L23) Map: delta = 50eV, 1115eV - 1165eV
Ga = EELS.SImage - Ga_L23;
Ga_map = sum(Ga(:,:,265:315),3);
subplot 132
imshow(uint64(Ga_map),[0 max(Ga_map(:))])
title('Galium (L23) Map')

% Arsenic (L23) Map: delta = 50eV, 1323eV - 1373eV
As = EELS.SImage - As_L23;
As_map = sum(As(:,:,473:523),3);
subplot 133
imshow(uint64(As_map),[0 max(As_map(:))])
title('Arsenic (L23) Map');

%figure( 'Name', 'Power-law fit' );
%hold on
%h = plot( fitresult, EELS.energy_loss_axis, squeeze(EELS.SImage(25,23,:)) );

%plot( fitresult1, EELS.energy_loss_axis, squeeze(EELS.SImage(25,23,:)) );

%legend( h, 'EELS vs. Energy-loss', 'Power-law fit', 'Location', 'NorthEast' );
%xlabel Energy-loss
%ylabel EELS
%grid on

%figure( 'Name', 'Power-law fit' );
%hold on
%plot( fitresult, EELS.energy_loss_axis, squeeze(EELS.SImage(52,22,:)) );
%legend( 'EELS vs. Energy-loss', 'Power-law fit', 'Location', 'NorthEast' );
%xlabel Energy-loss
%ylabel EELS
%grid on