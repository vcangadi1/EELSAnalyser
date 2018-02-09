clc
clear all

load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
I = sum(EELS.SImage,3);
BW = region3_950eVoff_mask(I);
S = squeeze(sum(sum(EELS.SImage.*repmat(BW,1,1,EELS.SI_z),2))/sum(BW(:)>0));
l = EELS.energy_loss_axis';

EELZ = load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
EELZ = EELZ.EELS;
EELZ = change_dispersion(EELZ,1);
EELZ = change_dimension(EELZ,EELS.SI_x,EELS.SI_y);
Z = squeeze(sum(sum(EELZ.SImage.*repmat(BW,1,1,EELZ.SI_z),2))/sum(BW(:)>0));
lz = EELZ.energy_loss_axis';

lz = calibrate_zero_loss_peak(lz,Z,'gauss');

[Wp,Ep] = plasmon_fit(lz,Z);
W0 = zero_loss_fit(lz,Z);

%%
f = Power_law(l(1:260),S(1:260));
a = f.a;
r = -f.b;
B = feval(Power_law(l(1:260),S(1:260)),l);

%%
dfcGa = diffCS_L23(31,1115,197,16.6,l);

dfcAs = diffCS_L23(33,1323,197,16.6,l);

dfc = [dfcGa, dfcAs];

X = [B,dfcGa,dfcAs];

p = regress(S, X);

%%

%S = exp(medfilt1(log(abs(S)),10,'truncate'));
%S = exp(medfilt1(log(abs(S)),10,'truncate'));

for ii = 0:0.5:3
    tl = 0.3*ii*2;
    ll = low_loss(lz,Ep,Wp,tl,W0);
    
    pdfc = plural_scattering(dfc,ll);
    
    X = [B,pdfc];
    
    %SS = hankel(atan(gradient(X*p)*180/pi));
    SS = hankel(atan(gradient(X*p)./(a*l.^(-r)))*180/pi);
    SS = SS(1:25,:);
    
    Sm = nanmean(SS);
    Ss = nanstd(SS);
    
    if tl >= 0.7
        figure(2)
        plotEELS(l+Ep,Sm+ii)
    elseif tl >= 1.4
        figure(2)
        plotEELS(l+2*Ep,Sm+ii)
    else
        figure(2)
        plotEELS(l,Sm+ii)
    end
end
