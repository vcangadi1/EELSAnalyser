clc

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
%%
load('Ge-basedSolarCell_24082015/tl.mat')
load('Ge-basedSolarCell_24082015/mask90x44.mat')
%EELS.SImage = EELS.SImage ./ repmat(tl,1,1,EELS.SI_z);
EELS.SImage = EELS.SImage .* repmat(mask90x44,1,1,EELS.SI_z);
%%
[I,f] = spectrum_image(EELS);

%{
%% Fast Marching Method
mask = roipoly;
close (f)

W = graydiffweight(I, mask, 'GrayDifferenceCutoff',5);

thresh = 0.1;
[BW, D] = imsegfmm(W, mask, thresh);
figure
imshow(BW)
title('Segmented Image')

figure
imshow(D)
title('Geodesic Distances')
%}
%% kmeans
nrows = size(I,1);
ncols = size(I,2);
ab = reshape(I,nrows*ncols,1);
[cluster_idx, cluster_center] = kmeans(I(:),8,'distance','sqEuclidean', ...
                                      'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);
figure;
imshow(pixel_labels,[]), title('image labeled by cluster index');
colorbar;
%%