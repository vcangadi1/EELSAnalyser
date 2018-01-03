function [F,mu,Std,Corr,parameters,rsq] = voigt2Dfit(Image2DSpectrum, r_axis, c_axis)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       Image2DSpectrum - a 2D signal.
%                r_axis - (Optional) non-dispersive k axis
%                c_axis - (Optional) energy-loss axis
% Output:
%                     F - Estimated fit for 2D signal 'Image'.
%                    mu - Mean of 2D distribution or Peak locations.
%                   Std - Standard devaitions of 2D distribution.
%                         Considering 0 covariance.
%            parameters - Fitting parameters.
%                   rsq - R-square value of the fit.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
I = Image2DSpectrum;
x = size(I,2); % columns
y = size(I,1); % rows

if nargin < 2
    [c,r] = meshgrid(1:x,1:y);
    p0 = [1E9,65,73,10,10,0.5,1E5];
    lb = [100,50,60,10,1,0,1E0];
    ub = [1E10,80,90,1000,1000,1,1E10];
elseif nargin < 3
    [c,r] = meshgrid(1:x,r_axis);
    p0 = [1E9,186,0,1,1,0.5];
    lb = [100,150,-1,0,0,0];
    ub = [1E10,200,1,1000,1000,1E10];
elseif nargin < 4
    [c,r] = meshgrid(c_axis,r_axis);
    p0 = [1E5,0,0,0.001,0.001,0.005,1E5];
    lb = [1E4,-1,-1,0,0,0,1E0];
    ub = [1E6,1,1,0.1,0.1,0.1,1E10];
end

%% 2D gaussian fit

%fit_error = @(p) sum(sum((I-dwt2([conv2(p(1)*reshape(mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x),p(7)*reshape(mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x)),ones(2*y-1,1);ones(1,2*x)],'db1')).^2));
fit_error = @(p) sum(sum((I-imresize([conv2(p(1)*reshape(mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x),p(7)*reshape(mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x)),ones(2*y-1,1);ones(1,2*x)],[y x])).^2));

options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});

p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);

%% Output

mu = [p(3),p(2)]; %[row,column]

Std = [sqrt(p(5)),0;0,sqrt(p(4))]; % p(4) and p(5) are variance
                                   % [row,column]

Corr = [1,p(6);p(6),1];

parameters = p;

%F = p(1)*conv2(reshape(mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x),reshape(mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x),'same');
F = dwt2([conv2(p(1)*reshape(mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x),p(7)*reshape(mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x)),ones(2*y-1,1);ones(1,2*x)],'db1');

rsq = rsquare(I,F);