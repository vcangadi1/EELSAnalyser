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

gI = gradient(I);
ggI = gradient(gI);

%% Create Texture Image

E = entropyfilt(gI);

Eim = mat2gray(E);
imshow(Eim);

%% Create Rough Mask for the Bottom Texture

BW1 = imbinarize(Eim, .8);

figure;
subplot 121
imshow(BW1);
subplot 122
imshow(I,[min(I(:)) max(I(:))]);

%%
BWao = bwareaopen(BW1,2000);
imshow(BWao);

%%
nhood = true(9);
closeBWao = imclose(BWao,nhood);
imshow(closeBWao)
%%
roughMask = imfill(closeBWao,'holes');

%% Use Rough Mask to Segment the Top Texture

figure;
subplot 121
imshow(I,[min(I(:)) max(I(:))]);
subplot 122
imshow(roughMask);

%%

I2 = I;
I2(roughMask) = 0;
imshow(I2);

%%

E2 = entropyfilt(I2);
E2im = mat2gray(E2);
imshow(E2im);

%%

BW2 = imbinarize(E2im);
imshow(BW2)
figure, imshow(I);

%%

mask2 = bwareaopen(BW2,1000);
imshow(mask2);

%% Display Segmentation Results

texture1 = I; %gI
texture1(~mask2) = 0;
texture2 = I; %gI
texture2(mask2) = 0;
imshow(texture1);
figure, imshow(texture2);

%%

boundary = bwperim(mask2);
segmentResults = gI; %gI
segmentResults(boundary) = 255;
imshow(segmentResults);

%% Using Other Texture Filters in Segmentation

S = stdfilt(gI,nhood); %gI
imshow(mat2gray(S));

R = rangefilt(gI,ones(5)); %gI
imshow(R,[min(R(:)) max(R(:))]);