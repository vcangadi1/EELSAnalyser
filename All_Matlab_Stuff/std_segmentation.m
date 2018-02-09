clc
close all

%%

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
if iscolumn(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis;
else
    l = EELS.energy_loss_axis';
end

I = sum(EELS.SImage,3);
I = medfilt2(I,'symmetric');

%%

fun = @(block_struct) ...
   std2(block_struct.data) * ones(size(block_struct.data));
I2 = blockproc(I,[2 2],fun);

figure(1)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
title('Spectrum Image')
axis image

subplot 132
imshow(I2,[]);
title('Segmented Image')
axis image