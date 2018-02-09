clc
close all 

load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\EELS');

%figure (1);
%I = sum(EELS.SImage,3);
%subplot 121
%imshow(uint64(I),[min(I(:)) max(I(:))]);

i = input('row = ');
j = input('column = ');

E_avg = squeeze(EELS.SImage(i,j-1,:)+EELS.SImage(i,j+1,:))/2;

EELS.SImage(i,j,:) = E_avg;
save('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\EELS','EELS');
%I = sum(EELS.SImage,3);
%subplot 122
%imshow(uint64(I),[min(I(:)) max(I(:))]);

%figure(2);
%plot(EELS.energy_loss_axis,squeeze(EELS.SImage(i,j-1,:)));
%hold on
%plot(EELS.energy_loss_axis,squeeze(EELS.SImage(i,j+1,:)));
%plot(EELS.energy_loss_axis,E_avg);
%hold off