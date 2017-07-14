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

%% input variables

% pixel location
%ii = 28;
%jj = 10;

% load core-loss spectrum and energy-loss
%load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
%load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
%l = EELS.energy_loss_axis';
%S = squeeze(EELS.SImage(ii,jj,:));
%S = feval(Spline(l,S),l);

% Load low-loss spectrum and energy-loss
%EELZ = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
%EELZ = load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
%EELZ = EELZ.EELS;

% Resample low-loss data
%ll = resample(squeeze(EELZ.SImage(ii,jj,:)),1,round(EELS.dispersion/EELZ.dispersion));

% Atomic Num
%Atomic_Num = [29,31,33];

% Energy onset in eV
%Energy_onset_eV = [923,1115,1323];

% Beam energy in kV
%E0 = 197;

% Collection angle in mrad
%beta = 16.6;

% Load differential cross sections
%tic;
%dfcCu = diffCS_L23(Atomic_Num(1),Energy_onset_eV(1),E0,beta,l);
%dfcGa = diffCS_L23(Atomic_Num(2),Energy_onset_eV(2),E0,beta,l);
%dfcAs = diffCS_L23(Atomic_Num(3),Energy_onset_eV(3),E0,beta,l);
%dfc = [dfcCu, dfcGa, dfcAs];
%toc;


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