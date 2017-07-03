clc

%EELS=readEELSdata;

A = EELSmatrix(EELS.SImage);

AMean = mean(A);
AStd = std(A);
B = (A - repmat(AMean,[EELS.SI_z,1])) ./ repmat(AStd,[EELS.SI_z,1]);
%B = (A - repmat(AMean,[z 1]));

[COEFF,SCORE,LATENT] = pca(B);

%% Create figure
figure1 = figure;
axes1 = axes('Parent',figure1,'YScale','log');
% Create axes
box(axes1,'on');
hold(axes1,'on');

% Create semilogy
semilogy(LATENT,'MarkerSize',4,'Marker','*','LineWidth',1,'LineStyle','--');

%plot((LATENT),'--*','LineWidth',1,'MarkerSize',4)

%% Reconstruct PCA with its components
%

%CLatent=cumsum(var(SCORE)) / sum(var(SCORE));
%CLatent(CLatent>=0.9998)=0;

%
C=COEFF;
C(:,5:end)=0;

REELS=(SCORE*C').*repmat(AStd,[EELS.SI_z,1])+repmat(AMean,[EELS.SI_z,1]);
%REELS=(SCORE*C')+repmat(AMean,[z,1]);
R = EELScube(REELS,EELS.SI_x,EELS.SI_y);
figure;
hold on
plot(EELS.energy_loss_axis,squeeze(EELS.SImage(1,1,:)))
plot(EELS.energy_loss_axis,REELS(:,1))
hold off