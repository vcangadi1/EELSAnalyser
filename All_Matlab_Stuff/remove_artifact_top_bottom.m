clc
close all

load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\EELS');

%figure (1);
%I = sum(EELS.SImage,3);
%subplot 121
%imshow(uint64(I),[min(I(:)) max(I(:))]);

i = input('row = ');
j = input('column = ');

E_avg = squeeze(EELS.SImage(i-1,j,:)+EELS.SImage(i+1,j,:))/2;

EELS.SImage(i,j,:) = E_avg;
save('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\EELS','EELS');
%I = sum(EELS.SImage,3);
%subplot 122
%imshow(uint64(I),[min(I(:)) max(I(:))]);

%figure(2);
%plot(EELS.energy_loss_axis,squeeze(EELS.SImage(i-1,j,:)));
%hold on
%plot(EELS.energy_loss_axis,squeeze(EELS.SImage(i+1,j,:)));
%plot(EELS.energy_loss_axis,E_avg);
%hold off
%legend('top','bottom','average');