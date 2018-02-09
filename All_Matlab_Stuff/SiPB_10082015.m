clc
close all

[EELS]=readEELSdata;
REELS=EELS;
[x,y,z] = size(REELS);

figure;
plot(EELS.energy_loss_axis,squeeze(EELS.SImage(1,1,:)))

REELS = PCA_denoise(EELS);

leftE = sum(reshape(REELS(:,8,:),x,z),1);

rightE = sum(reshape(REELS(:,9,:),x,z),1);

fitresult = Power_law(e_loss(70:150),rightE(70:150));

EELS_Components = EELS_PCA_Components(EELS);

figure;
hold on
grid on
plot(e_loss,leftE,'LineWidth',2)
plot(e_loss,rightE,'LineWidth',2)
legend({'Left Column','Right Column'},'FontWeight','bold');
xlabel('Energy-loss (eV)');
ylabel('Count');

% Create a figure for the plots.
figure( 'Name', 'Power-law fit' );

% Plot fit with data.
%subplot( 2, 1, 1 );
h = plot( fitresult, e_loss, rightE );
legend( h, 'right-EELS vs. energy-loss', 'Power-law fit', 'Location', 'NorthEast' );
% Label axes
xlabel e_loss
ylabel rightE
grid on