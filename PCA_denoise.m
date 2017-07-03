function EELS = PCA_denoise(EELS)
%   INPUT: 
%       EELSdata_cube = EELS Spectrum Image (SI) eg: 16 x 16 x 1024
%       Comp_Num      = (Optional) Number of components needed to
%                       reconstruct the EELS. If not defined, it is chosen at 10
%
%   OUTPUT:
%       EELS_denoised = Reconstructed denoised EELS data cube

%% If Comp_Num is not defined define the EELS.PCA.Comp_Num
if(isfield(EELS,'PCA'))
    if(isfield(EELS.PCA,'Comp_Num'))
        if(EELS.PCA.Comp_Num==0)
            EELS.PCA.Comp_Num=10;
        end
    else
        EELS.PCA.Comp_Num=10;
    end
else
    EELS.PCA.Comp_Num=10;
end

A = EELSmatrix(EELS.SImage);

AMean = mean(A);
AStd = std(A);
B = (A - repmat(AMean,[EELS.SI_z 1])) ./ repmat(AStd,[EELS.SI_z 1]);
%B = A;
[COEFF,SCORE,LATENT] = pca(B);

%% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YScale','log');
box(axes1,'on');
hold(axes1,'on');

% Create semilogy
semilogy(LATENT,'MarkerSize',4,'Marker','*','LineWidth',1,'LineStyle','--');

%% Reconstruct PCA with its components
COEFF(:,EELS.PCA.Comp_Num+1:end)=0;
%REELS=(SCORE*COEFF');
REELS=(SCORE*COEFF').*repmat(AStd,[EELS.SI_z,1])+repmat(AMean,[EELS.SI_z,1]);
%REELS=(SCORE*C')+repmat(AMean,[z,1]);
%figure;
%plot(REELS(:,1))

%% Rearrange data cube
EELS.PCA.denoised = EELScube(REELS,EELS.SI_x,EELS.SI_y);
strucdisp(EELS.PCA);