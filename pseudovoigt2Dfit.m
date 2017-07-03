function [F,mu,Std,Corr,parameters,rsq] = pseudovoigt2Dfit(Image)
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
I = Image;
x = size(I,2); % columns
y = size(I,1); % rows

%% 2D gaussian fit
[c,r] = meshgrid(1:x,1:y);

fit_error = @(p) sum(sum((I-p(1)*(reshape(p(7).*mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x)+reshape((1-p(7))*mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x))).^2));

%p0 = [1E9,186,132,611,577];
%p0 = [1,1,1,1,1,0.5,0.5];
p0 = [1E9,186,132,611,577,0.5,0.5];

options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});

%lb = [100,150,100,10,1];
%lb = [1,1,100,1,1,0,0.01];
lb = [100,150,100,10,1,0,0.01];

%ub = [1E10,200,200,1000,1000];
%ub = [];
ub = [1E10,200,200,1000,1000,1,1];

p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);

%% Output

F = p(1)*(reshape(p(7).*mvnpdf([c(:) r(:)],[p(2),p(3)],[p(4),0;0,p(5)]), y, x)+reshape((1-p(7))*mvtpdf([c(:) r(:)],[1,p(6);p(6),1],1), y, x));

mu = [p(2),p(3)];

Std = [sqrt(p(4)),0;0,sqrt(p(5))]; %p(4) and p(5) are variance

Corr = [1,p(6);p(6),1];

parameters = p;

rsq = rsquare(I,F);