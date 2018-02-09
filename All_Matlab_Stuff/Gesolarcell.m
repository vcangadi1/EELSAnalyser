clc
close all

%EELS = readEELSdata('Ge-basedSolarCell_24082015\.dm3');
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

I = max(EELS.SImage, [], 3);
I(I<2000) = 0;
I(I>2000) = 1;

EELS.SImage = EELS.SImage.*repmat(I,[1,1,EELS.SI_z]);

plotEELS(EELS);
C_K = zeros(size(EELS.SImage));
O_K = zeros(size(EELS.SImage));
In_M45 = zeros(size(EELS.SImage));

for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        EELS.SImage(i,j,:) = medfilt1(squeeze(EELS.SImage(i,j,:)),10);
        E = squeeze(EELS.SImage(i,j,:))';
        fitresult = Power_law(EELS.energy_loss_axis(80:160),E(80:160));
        C_K(i,j,:) = [squeeze(EELS.SImage(i,j,1:79));fitresult(EELS.energy_loss_axis(80:end))];
        fitresult1 = Power_law(EELS.energy_loss_axis(550:650),E(550:650));
        O_K(i,j,:) = [squeeze(EELS.SImage(i,j,1:549));fitresult1(EELS.energy_loss_axis(550:end))];
        fitresult2 = Power_law(EELS.energy_loss_axis(340:440),E(340:440));
        In_M45(i,j,:) = [squeeze(EELS.SImage(i,j,1:339));fitresult2(EELS.energy_loss_axis(340:end))];
    end
end

% Carbon (K) Map: delta = 50eV, 284eV - 334eV
C = EELS.SImage - C_K;
C_map = sum(C(:,:,168:268),3);
subplot 131
imshow(uint64(C_map),[min(C_map(:)) max(C_map(:))])
title('Carbon (K) Map')

% Indium (M45) Map: delta = 50eV, 441eV - 491eV
In = EELS.SImage - In_M45;
In_map = sum(In(:,:,482:582),3);
subplot 132
imshow(uint64(In_map),[min(In_map(:)) max(In_map(:))])
title('Indium (M45) Map')

% Oxygen (K) Map: delta = 50eV, 532eV - 582eV
O = EELS.SImage - O_K;
O_map = sum(O(:,:,482:582),3);
subplot 133
imshow(uint64(O_map),[min(O_map(:)) max(O_map(:))])
title('Oxygen (K) Map');

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