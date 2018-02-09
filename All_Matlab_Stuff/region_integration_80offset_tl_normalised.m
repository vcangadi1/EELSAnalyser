load('Ge-basedSolarCell_24082015/new_artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')
load('Ge-basedSolarCell_24082015/tl_nozero_45x22.mat');
load('Ge-basedSolarCell_24082015/mask45x22.mat');

EELS.SImage = EELS.SImage .* repmat(mask45x22,1,1,EELS.SI_z);
EELS.SImage = EELS.SImage ./ repmat(tl45x22,1,1,EELS.SI_z);


%% Region 1
I1 = sum(EELS.SImage,3);
I1 = imrotate(I1,23.19859);
SImage = zeros(size(I1,1),size(I1,2),EELS.SI_z);
%figure;
%imshow(uint32(I1),[min(abs(I1(:))) max(I1(:))])
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end

I1(1:9,:) = 0;
I1(10:12,:) = 1;
I1(13:end,:) = 0;

SImage = SImage.*repmat(I1,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I1,temp,'montage')
%S1_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S1_80 = squeeze(sum(sum(SImage,1),2));
%% Region 2
I2 = sum(EELS.SImage,3);
I2 = imrotate(I2,23.19859);
SImage = zeros(size(I2,1),size(I2,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end

I2(1:12,:) = 0;
I2(13:16,:) = 1;
I2(17:end,:) = 0;

SImage = SImage.*repmat(I2,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I2,temp,'montage')
%S2_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S2_80 = squeeze(sum(sum(SImage,1),2));
%% Region 3
I3 = sum(EELS.SImage,3);
I3 = imrotate(I3,23.19859);
SImage = zeros(size(I3,1),size(I3,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I3(1:17,:) = 0;
I3(18:23,:) = 1;
I3(24:end,:) = 0;

SImage = SImage.*repmat(I3,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I3,temp,'montage')
%S3_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S3_80 = squeeze(sum(sum(SImage,1),2));
%% Region 4
I4 = sum(EELS.SImage,3);
I4 = imrotate(I4,23.19859);
SImage = zeros(size(I4,1),size(I4,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I4(1:23,:) = 0;
I4(24:25,:) = 1;
I4(26:end,:) = 0;

SImage = SImage.*repmat(I4,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I4,temp,'montage')
%S4_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S4_80 = squeeze(sum(sum(SImage,1),2));
%% Region 5
I5 = sum(EELS.SImage,3);
I5 = imrotate(I5,23.19859);
SImage = zeros(size(I5,1),size(I5,2),EELS.SI_z);
for i =1:EELS.SI_z,
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I5(1:25,:) = 0;
I5(26:35,:) = 1;
I5(36:end,:) = 0;

SImage = SImage.*repmat(I5,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I5,temp,'montage')
%S5_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S5_80 = squeeze(sum(sum(SImage,1),2));
%% Region 6
I6 = sum(EELS.SImage,3);
I6 = imrotate(I6,23.19859);
SImage = zeros(size(I6,1),size(I6,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I6(1:35,:) = 0;
I6(36:37,:) = 1;
I6(38:end,:) = 0;

SImage = SImage.*repmat(I6,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I6,temp,'montage')
%S6_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S6_80 = squeeze(sum(sum(SImage,1),2));
%% Region 7
I7 = sum(EELS.SImage,3);
I7 = imrotate(I7,23.19859);
SImage = zeros(size(I7,1),size(I7,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I7(1:36,:) = 0;
I7(37:38,:) = 1;
I7(39:end,:) = 0;

SImage = SImage.*repmat(I7,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I7,temp,'montage')
%S7_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S7_80 = squeeze(sum(sum(SImage,1),2));

%% Region 8
I8 = sum(EELS.SImage,3);
I8 = imrotate(I8,23.19859);
SImage = zeros(size(I8,1),size(I8,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I8(1:38,:) = 0;
I8(39:end,:) = 1;

SImage = SImage.*repmat(I8,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I8,temp,'montage')
%S8_80 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S8_80 = squeeze(sum(sum(SImage,1),2));
%%
close all