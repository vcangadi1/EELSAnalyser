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

%% Binary image segmentation using Fast Marching Method

mask = false(size(I));
mask(1,20) = true;

W = graydiffweight(gradient(I), mask, 'GrayDifferenceCutoff', 10);

thresh = 0.2;
[BW, D] = imsegfmm(W, mask, thresh);
figure(1)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
title('Spectrum Image')
axis image

subplot 132
imshow(BW)
title('Segmented Image')
axis image

subplot 133
imshow(D)
title('Geodesic Distances')
axis image

%% Based on image gradient

sigma = 1.5;
W = gradientweight(gradient(I), sigma, 'RolloffFactor', 3, 'WeightCutoff', 0.6);

R = 55; C = 20;

figure(2)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
axis image
hold on;
plot(C, R, 'r.', 'LineWidth', 1.5, 'MarkerSize',15);
title('Original Image with Seed Location')
axis image

thresh = 0.1;
[BW, D] = imsegfmm(W, C, R, thresh);

subplot 132
imshow(BW)
title('Segmented Image')
hold on;
plot(C, R, 'r.', 'LineWidth', 1.5, 'MarkerSize',15);

subplot 133
imshow(D)
title('Geodesic Distances')
hold on;
plot(C, R, 'r.', 'LineWidth', 1.5, 'MarkerSize',15);

%% Based on grayscale intensity difference

figure(3)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
axis image

seedpointR = 55;
seedpointC = 20;

W = graydiffweight(uint32(I), seedpointC, seedpointR);%,'GrayDifferenceCutoff',10);

subplot 132
imshow(log(W),[])
axis image

thresh = 0.2;
BW = imsegfmm(W, seedpointC, seedpointR, thresh);

subplot 133
imshow(BW)
title('Segmented Image')

%% Gray connented

seedrow = 55;
seedcol = 20;
tol = 10000;
BW = grayconnected(gradient(I),seedrow,seedcol,tol);

figure(4)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
hold on
plot(seedcol, seedrow, 'r.', 'LineWidth', 1.5, 'MarkerSize',15);
title('Original Image with Seed Location')
axis image

subplot 122
imshow(BW)
title('Segmented Image')
hold on
plot(seedcol, seedrow, 'r.', 'LineWidth', 1.5, 'MarkerSize',15);
axis image

%% Global image threshold using Otsu's method

level = graythresh(I);
BW = im2bw(I,level);

figure(5)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 122
imshow(BW)
title('Segmented Image')
axis image

%% Multilevel image thresholds using Otsu's method

% Two segment
level = multithresh(I);

seg_I = imquantize(I,level);

figure(6)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 132
imshow(seg_I,[])
title('Segment Image Into Two Regions')

% Three segment
thresh = multithresh(I,2);

seg_I = imquantize(I,thresh);

RGB = label2rgb(seg_I);

subplot 133
imshow(RGB)
axis off
title('RGB Segmented Image')


%% Global histogram threshold using Otsu's method

[counts,x] = imhist(I,16);

figure(7)
subplot 131
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 132
stem(x,counts)
title('Image histogram')

T = otsuthresh(counts);

BW = imbinarize(I,T);

subplot 133
imshow(BW)
title('Segmented Image')
axis image

%% Adaptive image threshold using local first-order statistics
%%%%%%Gradient I is used

T = adaptthresh(gradient(I), 0.8);

BW = imbinarize(gradient(I),T);

figure(8)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 122
imshow(BW)
title('Segmented Image')
axis image

%% Find region boundaries of segmentation
%%%%%%Gradient I is used

L = superpixels(gradient(I),100);

conn = 4; % or 8
mask = boundarymask(L,conn);

figure(9)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 122
imshow(mask)
title('Segmented Image')
axis image

%% Texture Segmentation Using Gabor Filters

imageSize = size(I);
numRows = imageSize(1);
numCols = imageSize(2);

wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 10;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);

gabormag = imgaborfilt(I,g);

for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma);
end

X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag,X);
featureSet = cat(3,featureSet,Y);

numPoints = numRows*numCols;
X = reshape(featureSet,numRows*numCols,[]);

X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide,X,std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1),numRows,numCols);

figure(10)
subplot 121
imshow(I,[min(I(:)) max(I(:))])
title('Original Image')

subplot 122
imshow(feature2DImage,[])
title('Gabor filter')

%% Watershed Segmentation

W = watershed(gradient(gradient(I)));
rgb = label2rgb(W,'jet',[.5 .5 .5]);

figure(11)
imshow(rgb);
axis image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PCA to EELS map as a function of delta

SI = @(r,c) squeeze(EELS.SImage(r,c,:));
bS = zeros(size(EELS.SImage));
t1 = tic;
for ii=1:EELS.SI_x,
    for jj=1:EELS.SI_y,
        S = SI(ii,jj);
        bS(ii,jj,:) = S-feval(Power_law(l(100:265),S(100:265)),l);
    end
end
toc(t1);

%bS(bS<0) = 0;

Sm = reshape(bS,[],1024);
%%

[COEFF,SCORE,LATENT] = pca(Sm);

C = COEFF;
C(:,2:end) = 0;
Sr = SCORE*C';

x = Sr(:,200);
x = reshape(x,92,43);
figure(12)
imshow(x)
