clc
clear all

%% Load SI of high loss and low loss

EELS = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
EELS = EELS.EELS;
EELZ = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
EELZ = EELZ.EELS;
l = EELS.energy_loss_axis';

%% Load differential cross sections

dfcCu = diffCS_L23(29,923,197,16.6,l);
dfcGa = diffCS_L23(31,1115,197,16.6,l);
dfcAs = diffCS_L23(33,1323,197,16.6,l);

%% fit background

for ii = EELS.SI_x:-1:1
    for jj = EELS.SI_y:-1:1
        S = squeeze(EELS.SImage(ii,jj,:));
        S = feval(Spline(l,S),l);
        B(ii,jj,1:EELS.SI_z) = feval(Exponential_fit(l(1:63),S(1:63)),l);
    end
end

EELB = EELS;
EELB.SImage = B;

plotEELS(EELB)