function [R, COEFF, SCORE, LATENT] = EELSPCA(Image2DSpectrum, Pnum, Option)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       Image2DSpectrum - a 2D signal.
%                  Pnum - (Optional) number of PCA component that needs to
%                         be retained.
%                Option - 'Only' or 'First'
% Output:
%                     R - Reconstructed spectrum after PCA.
%                 COEFF - Coefficients of PCA.
%                 SCORE - Score of PCA.
%                LATENT - Variance.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

A = Image2DSpectrum;

AMean = mean(A);
AStd = std(A);

r = size(A,1);

if nargin < 2
    Pnum = r - 1;
end

if nargin < 3
    Option = 'first';
end

B = (A - repmat(AMean,[r,1])) ./ repmat(AStd,[r,1]);

[COEFF,SCORE,LATENT] = pca(B);

%% Create figure

figure1 = figure;
axes1 = axes('Parent',figure1,'YScale','log');

% Create axes

box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(LATENT,'MarkerSize',4,'Marker','*','LineWidth',1,'LineStyle','--');

grid on

%% Reconstruct

if strcmpi(Option, 'first')
    C = COEFF;
    C(:,Pnum+1:end) = 0;
elseif strcmpi(Option, 'only')
    C = zeros(size(COEFF));
    C(:,Pnum) = COEFF(:,Pnum);
end

R = (SCORE*C') .* repmat(AStd,[r,1]) + repmat(AMean,[r,1]);