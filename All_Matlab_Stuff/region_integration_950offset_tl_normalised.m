load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
load('Ge-basedSolarCell_24082015/tl_nozero.mat');
load('Ge-basedSolarCell_24082015/mask90x44.mat');

EELS.SImage = squeeze(EELS.SImage(1:end-2,:,:)) .* repmat(mask90x44(:,1:43),1,1,EELS.SI_z);
EELS.SImage = EELS.SImage ./ repmat(tl(:,1:43),1,1,EELS.SI_z);

%% Region 1
I1 = sum(EELS.SImage,3);
I1 = imrotate(I1,23.19859);
SImage = zeros(size(I1,1),size(I1,2),EELS.SI_z);
%figure;
%imshow(uint32(I1),[min(abs(I1(:))) max(I1(:))])
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end

I1(1:18,:) = 0;
I1(19:23,:) = 1;
I1(24:end,:) = 0;

SImage = SImage.*repmat(I1,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I1,temp,'montage')
%S1_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S1_950 = squeeze(sum(sum(SImage,1),2));
%% Region 2
I2 = sum(EELS.SImage,3);
I2 = imrotate(I2,23.19859);
SImage = zeros(size(I2,1),size(I2,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end

I2(1:23,:) = 0;
I2(24:32,:) = 1;
I2(33:end,:) = 0;

SImage = SImage.*repmat(I2,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I2,temp,'montage')
%S2_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S2_950 = squeeze(sum(sum(SImage,1),2));
%% Region 3
I3 = sum(EELS.SImage,3);
I3 = imrotate(I3,23.19859);
SImage = zeros(size(I3,1),size(I3,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I3(1:33,:) = 0;
I3(34:47,:) = 1;
I3(48:end,:) = 0;

SImage = SImage.*repmat(I3,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I3,temp,'montage')
%S3_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S3_950 = squeeze(sum(sum(SImage,1),2));
%% Region 4
I4 = sum(EELS.SImage,3);
I4 = imrotate(I4,23.19859);
SImage = zeros(size(I4,1),size(I4,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I4(1:48,:) = 0;
I4(49:50,:) = 1;
I4(51:end,:) = 0;

SImage = SImage.*repmat(I4,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I4,temp,'montage')
%S4_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S4_950 = squeeze(sum(sum(SImage,1),2));
%% Region 5
I5 = sum(EELS.SImage,3);
I5 = imrotate(I5,23.19859);
SImage = zeros(size(I5,1),size(I5,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I5(1:51,:) = 0;
I5(52:70,:) = 1;
I5(71:end,:) = 0;

SImage = SImage.*repmat(I5,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I5,temp,'montage')
%S5_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S5_950 = squeeze(sum(sum(SImage,1),2));
%% Region 6
I6 = sum(EELS.SImage,3);
I6 = imrotate(I6,23.19859);
SImage = zeros(size(I6,1),size(I6,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I6(1:70,:) = 0;
I6(71:73,:) = 1;
I6(74:end,:) = 0;

SImage = SImage.*repmat(I6,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I6,temp,'montage')
%S6_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S6_950 = squeeze(sum(sum(SImage,1),2));

%% Region 7
I7 = sum(EELS.SImage,3);
I7 = imrotate(I7,23.19859);
SImage = zeros(size(I7,1),size(I7,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I7(1:73,:) = 0;
I7(74:75,:) = 1;
I7(76:end,:) = 0;

SImage = SImage.*repmat(I7,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I7,temp,'montage')
%S7_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S7_950 = squeeze(sum(sum(SImage,1),2));

%% Region 8
I8 = sum(EELS.SImage,3);
I8 = imrotate(I8,23.19859);
SImage = zeros(size(I8,1),size(I8,2),EELS.SI_z);
for i =1:EELS.SI_z,    
    SImage(:,:,i) = imrotate(squeeze(EELS.SImage(:,:,i)),23.19859);
end
I8(1:75,:) = 0;
I8(76:end,:) = 1;

SImage = SImage.*repmat(I8,1,1,1024);
temp = sum(SImage,3);
figure;
imshowpair(I8,temp,'montage')
%S8_950 = squeeze(sum(sum(SImage,1),2))/sum(sum(temp>0));
S8_950 = squeeze(sum(sum(SImage,1),2));
%%
close all