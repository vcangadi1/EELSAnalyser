clc
close all

%%

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
if iscolumn(EELS.energy_loss_axis)
    l = EELS.energy_loss_axis;
else
    l = EELS.energy_loss_axis';
end

I = sum(EELS.SImage,3)*EELS.dispersion;
I = medfilt2(I,'symmetric');
%I = gradient(I);
%%

fun = @(block_struct) ...
   mean2(block_struct.data) * ones(size(block_struct.data));
I2 = blockproc(I,[2 2],fun,'BorderSize',[1,1]);

figure(1)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
title('Spectrum Image')
axis image

subplot 122
imshow(I2,[]);
title('Segmented Image')
axis image