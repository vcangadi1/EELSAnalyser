function [p,R2] = mlls_fit(core_loss_spectrum, energy_loss_HIGH_LOSS, model_begin_channel, model_end_channel, Diff_cross_sections, Optional_lowloss_spectrum)
%%

dfc = Diff_cross_sections;

% Plural scattering
if nargin == 6
    dfc = plural_scattering(dfc, Optional_lowloss_spectrum);
else
    dfc = Diff_cross_sections;
end

% high loss energy-loss axis
l = energy_loss_HIGH_LOSS;

% High loss spectrum
S = core_loss_spectrum;

%% Get Residue of the spectrum
% model background with exponential function
b = model_begin_channel;
e = model_end_channel;
rS = S - feval(Exponential_fit(l(b:e),S(b:e)),l);

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

%% display
disp([p(1) diff(p)]);
disp(R2);
figure;
plotEELS(l,rS)
plotEELS(l,fun(p,l))