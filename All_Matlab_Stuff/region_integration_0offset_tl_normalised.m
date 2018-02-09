load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
load('Ge-basedSolarCell_24082015/tl_nozero.mat');
load('Ge-basedSolarCell_24082015/mask90x44.mat');

EELS.SImage = EELS.SImage .* repmat(mask90x44,1,1,EELS.SI_z);
EELS.SImage = EELS.SImage ./ repmat(tl,1,1,EELS.SI_z);

%% Region 1
I1 = sum(EELS.SImage,3);
I1 = imrotate(I1,21.57130719);
SImage = zeros(size(I1,1),size(I1,2),EELS.SI_z);
%figure;
%imshow(uint32(I1),[min(abs(I1(:))) max(I1(:))])
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end

I1(1:18,:) = 0;
I1(19:22,:) = 1;
I1(23:end,:) = 0;

SImage = SImage.*repmat(I1,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I1,temp,'montage')
%S1_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S1_0 = squeeze(sum(sum(SImage,1),2));

%% Region 2
I2 = sum(EELS.SImage,3);
I2 = imrotate(I2,21.57130719);
SImage = zeros(size(I2,1),size(I2,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end

I2(1:22,:) = 0;
I2(23:31,:) = 1;
I2(32:end,:) = 0;

SImage = SImage.*repmat(I2,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I2,temp,'montage')
%S2_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S2_0 = squeeze(sum(sum(SImage,1),2));

%% Region 3
I3 = sum(EELS.SImage,3);
I3 = imrotate(I3,21.57130719);
SImage = zeros(size(I3,1),size(I3,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I3(1:33,:) = 0;
I3(34:47,:) = 1;
I3(48:end,:) = 0;

SImage = SImage.*repmat(I3,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I3,temp,'montage')
%S3_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S3_0 = squeeze(sum(sum(SImage,1),2));

%% Region 4
I4 = sum(EELS.SImage,3);
I4 = imrotate(I4,21.57130719);
SImage = zeros(size(I4,1),size(I4,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I4(1:47,:) = 0;
I4(48:49,:) = 1;
I4(50:end,:) = 0;

SImage = SImage.*repmat(I4,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I4,temp,'montage')
%S4_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S4_0 = squeeze(sum(sum(SImage,1),2));

%% Region 5
I5 = sum(EELS.SImage,3);
I5 = imrotate(I5,21.57130719);
SImage = zeros(size(I5,1),size(I5,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I5(1:50,:) = 0;
I5(51:72,:) = 1;
I5(73:end,:) = 0;

SImage = SImage.*repmat(I5,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I5,temp,'montage')
%S5_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S5_0 = squeeze(sum(sum(SImage,1),2));

%% Region 6
I6 = sum(EELS.SImage,3);
I6 = imrotate(I6,21.57130719);
SImage = zeros(size(I6,1),size(I6,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I6(1:72,:) = 0;
I6(73:75,:) = 1;
I6(76:end,:) = 0;

SImage = SImage.*repmat(I6,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I6,temp,'montage')
%S6_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S6_0 = squeeze(sum(sum(SImage,1),2));

%% Region 7
I7 = sum(EELS.SImage,3);
I7 = imrotate(I7,21.57130719);
SImage = zeros(size(I7,1),size(I7,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I7(1:75,:) = 0;
I7(76:78,:) = 1;
I7(79:end,:) = 0;

SImage = SImage.*repmat(I7,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I7,temp,'montage')
%S7_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S7_0 = squeeze(sum(sum(SImage,1),2));

%% Region 8
I8 = sum(EELS.SImage,3);
I8 = imrotate(I8,21.57130719);
SImage = zeros(size(I8,1),size(I8,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),21.57130719);
end
I8(1:79,:) = 0;
I8(80:end,:) = 1;

SImage = SImage.*repmat(I8,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I8,temp,'montage')
%S8_0 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S8_0 = squeeze(sum(sum(SImage,1),2));
%%
close all
