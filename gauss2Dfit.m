function [F,mu,Std,parameters,rsq] = gauss2Dfit(Image2DSpectrum, r_axis, c_axis)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%        Image - a 2D signal.
%
% Output:
%            F - Estimated fit for 2D signal 'Image'.
%           mu - Mean of 2D distribution or Peak locations.
%          Std - Standard devaitions of 2D distribution.
%                Considering 0 covariance.
%   parameters - Fitting parameters.
%          rsq - R-square value of the fit.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
I = Image2DSpectrum;
x = size(I,2); % columns
y = size(I,1); % rows

if nargin < 2
    [c,r] = meshgrid(1:x,1:y);
    p0 = [1,185,134,1,1];
    lb = [1,1,100,1,1];
    ub = [];
elseif nargin < 3
    [c,r] = meshgrid(1:x,r_axis);
    p0 = [1,150,0,1,1];
    lb = [1,1,-1,0,0];
    ub = [];
elseif nargin < 4
    [c,r] = meshgrid(c_axis,r_axis);
    p0 = [1,0,0,1,1];
    lb = [1,-1,-2,0,0];
    ub = [inf,1,2,inf,inf];
end

%% 2D gaussian fit

fit_error = @(p) sum(sum((I-reshape(p(1).*mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x)).^2));

options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});

p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);

%% Output

F = reshape(p(1).*mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x);

mu = [p(3),p(2)]; % [row,column]

Std = [sqrt(p(5)),0;0,sqrt(p(4))]; % p(4) and p(5) are variance
                                   % [row,column]

parameters = p;

rsq = rsquare(I,F);