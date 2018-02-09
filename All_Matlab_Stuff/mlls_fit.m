function [p, R2, fun, back] = mlls_fit(core_loss_spectrum, energy_loss_HIGH_LOSS, model_begin_channel, model_end_channel, Diff_cross_sections, Optional_lowloss_spectrum)
%%

dfc = Diff_cross_sections;

% Plural scattering
if nargin == 6
    dfc = plural_scattering(dfc, Optional_lowloss_spectrum);
end

% high loss energy-loss axis
l = energy_loss_HIGH_LOSS;

% High loss spectrum
S = core_loss_spectrum;

%% Get Residue of the spectrum
% model background with exponential function
b = model_begin_channel;
e = model_end_channel;
back = feval(Exponential_fit(l(b:e),S(b:e)),l);
rS = S - back;

%% define lb, ub, p0 for lsqcurvefit

lb = ones(1,size(dfc,2)) * 0;
ub = ones(1,size(dfc,2)) * 1E4;
p0 = ones(1,size(dfc,2)) * 30;

%% fit background
tic;
%fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
fun = @(p,l) dfc * p';
options = optimoptions(@lsqcurvefit,'display','none');
p = lsqcurvefit(fun,p0,l,rS,lb,ub,options);
R2 = rsquare(rS, fun(p,l));
toc;

%% Redefine simpler function
fun = @(p) dfc * p';

%% display
%disp(p);
%disp(R2);
%figure;
%plotEELS(l,rS)
%plotEELS(l,fun(p,l))