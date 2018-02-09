clc
clear all

%% Load high loss Solar Cell
%{
load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
I = sum(EELS.SImage,3);
BW = region8_950eVoff_mask(I);
S = squeeze(sum(sum(EELS.SImage.*repmat(BW,1,1,EELS.SI_z),2))/sum(BW(:)>0));
l = EELS.energy_loss_axis';
b = 1;
e = 260;
%}
%% Load High loss InGaN

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/100kV/EELS Spectrum Image6-b.dm3');
I = sum(EELS.SImage,3);
BW = Ga_rich_InGaN(I);
%BW = In_rich_InGaN(I);
S = squeeze(sum(sum(EELS.SImage.*repmat(BW,1,1,EELS.SI_z),2))/sum(BW(:)>0));
l = EELS.energy_loss_axis;
b = 1;
e = 100;

%% Load High loss AlN:Tb
%{
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/AlNTb-P14-800degree/EELS Spectrum Image1.dm3');
I = sum(EELS.SImage,3);
BW = Si_region_AlN(I);
%BW = AlN_region_AlN(I);
S = squeeze(sum(sum(EELS.SImage.*repmat(BW,1,1,EELS.SI_z),2))/sum(BW(:)>0));
S = S(12:467);
l = EELS.energy_loss_axis(12:467);
b = 12;
e = 29;
%}
%%
%EELZ = load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
%EELZ = EELZ.EELS;
%EELZ = change_dispersion(EELZ,1);
%EELZ = change_dimension(EELZ,EELS.SI_x,EELS.SI_y);
%Z = squeeze(sum(sum(EELZ.SImage.*repmat(BW,1,1,EELZ.SI_z),2))/sum(BW(:)>0));
%lz = EELZ.energy_loss_axis';


%lz = calibrate_zero_loss_peak(lz,Z,'gauss');

%[Wp,Ep] = plasmon_fit(lz,Z);
%W0 = zero_loss_fit(lz,Z);

%%

f = Power_law(l(b:e),S(b:e));
a = f.a;
r = -f.b;
B = feval(Power_law(l(b:e),S(b:e)),l);

%%
%dfcGa = diffCS_L23(31,1115,197,16.6,l);

%dfcAs = diffCS_L23(33,1323,197,16.6,l);

%dfc = [dfcGa, dfcAs];

%X = [B,dfcGa,dfcAs];

%p = regress(S, X);

%y = X*p;

%%

S = exp(medfilt1(log(abs(S)),10,'truncate'));
S = exp(medfilt1(log(abs(S)),10,'truncate'));

w = 25;

SS = hankel(atan(gradient(S)./(a*l.^(-r))));
%SS = hankel(atan(gradient(S)*180/pi));
SS = SS(1:w,:);

Sm = nanmean(SS);
Ss = nanstd(SS);

figure(1);
plotEELS(l,Sm)

%figure;
%plotEELS(l,X*p)