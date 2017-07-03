function EELS = EELS_PCA_Components(EELS)

%   INPUT: 
%       EELSdata_cube = EELS Spectrum Image (SI) eg: 16 x 16 x 1024
%
%   OUTPUT:
%       EELS_Components( Comp_Num ,SI_x ,SI_y, EELS_spectrum ) 
%           = Reconstructed individual PCA components of EELSdata_cube

%%
A = EELSmatrix(EELS.SImage);

AMean = mean(A);
AStd = std(A);
B = (A - repmat(AMean,[EELS.SI_z 1])) ./ repmat(AStd,[EELS.SI_z 1]);

[COEFF,SCORE,LATENT] = pca(B);

EELS.PCA.Coeff = COEFF;
EELS.PCA.Score = SCORE;
EELS.PCA.Variance = LATENT;


%EELS_Components = zeros(x*y,z,x*y);
EELS.PCA.Individual_Components = zeros(EELS.SI_x*EELS.SI_y,EELS.SI_x,EELS.SI_y,EELS.SI_z);


for i = 1:EELS.SI_x*EELS.SI_y,
    C=zeros(size(COEFF));
    C(:,i)=COEFF(:,i);
    %E(i,:,:)=(SCORE*C').*repmat(AStd,[z,1])+repmat(AMean,[z,1]);
    %EELS_Components(i,:,:,:)=EELScube(reshape(E(i,:,:),z,x*y),EELS.SI_x,y);
    EELS.PCA.Individual_Components(i,:,:,:)=reshape(EELScube(reshape((SCORE*C').*repmat(AStd,[EELS.SI_z,1])+repmat(AMean,[EELS.SI_z,1]),EELS.SI_z,EELS.SI_x*EELS.SI_y),EELS.SI_x,EELS.SI_y),EELS.SI_x,EELS.SI_y,EELS.SI_z);
end
strucdisp(EELS.PCA);