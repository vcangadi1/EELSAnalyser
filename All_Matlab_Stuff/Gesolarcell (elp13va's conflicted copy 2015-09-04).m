clc
close all

%EELS = readEELSdata('Ge-basedSolarCell_24082015\.dm3');
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')

I = max(EELS.SImage, [], 3);
I(I<2000) = 0;
I(I>2000) = 1;

EELS.SImage = EELS.SImage.*repmat(I,[1,1,EELS.SI_z]);

plotEELS(EELS);
%fitresult = zeros(size(EELS.SImage));
%fitresult1 = zeros(size(EELS.SImage));
%fitresult2 = zeros(size(EELS.SImage));

for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        E = squeeze(EELS.SImage(i,j,80:160))';
        fitresult = Power_law(EELS.energy_loss_axis(80:160),E);
        C_K(i,j,:) = fitresult(EELS.energy_loss_axis(80:end),squeeze(EELS.SImage(i,j,80:end))');
        E = squeeze(EELS.SImage(i,j,550:650))';
        fitresult1 = Power_law(EELS.energy_loss_axis(550:650),E);
        In_M45(i,j,:) = fitresult1(EELS.energy_loss_axis(550:end),squeeze(EELS.SImage(i,j,550:end))');
        E = squeeze(EELS.SImage(i,j,340:440))';
        fitresult2 = Power_law(EELS.energy_loss_axis(340:440),E);
        O_K(i,j,:) = fitresult2(EELS.energy_loss_axis(340:end),squeeze(EELS.SImage(i,j,340:end))');
    end
end


%figure( 'Name', 'Power-law fit' );
%hold on
%h = plot( fitresult, EELS.energy_loss_axis, squeeze(EELS.SImage(25,23,:)) );

%plot( fitresult1, EELS.energy_loss_axis, squeeze(EELS.SImage(25,23,:)) );

%legend( h, 'EELS vs. Energy-loss', 'Power-law fit', 'Location', 'NorthEast' );
%xlabel Energy-loss
%ylabel EELS
%grid on

%figure( 'Name', 'Power-law fit' );
%hold on
%plot( fitresult, EELS.energy_loss_axis, squeeze(EELS.SImage(52,22,:)) );
%legend( 'EELS vs. Energy-loss', 'Power-law fit', 'Location', 'NorthEast' );
%xlabel Energy-loss
%ylabel EELS
%grid on