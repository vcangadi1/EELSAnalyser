clc

load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')

EELS.PCA.Comp_Num = 10;
EELS = PCA_denoise(EELS);
EELS.SImage = EELS.PCA.denoised;
h = plotEELS(EELS);

w = 30;
r = zeros(size(EELS.SImage));
r(:,:,1:w/2) = NaN;
r(:,:,EELS.SI_z-w/2:EELS.SI_z) = NaN;

for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        for k = w/2:EELS.SI_z-w/2,
            fitresult = Poly_1(EELS.energy_loss_axis(k-w/2+1:k+w/2)',squeeze(EELS.SImage(i,j,k-w/2+1:k+w/2)));
            r(i,j,k) = fitresult.p1;
        end
    end
end

r(:,:,1:w/2) = r(:,:,w/2+1);
r(:,:,EELS.SI_z-w/2:EELS.SI_z)=r(:,:,EELS.SI_z-w/2-1);