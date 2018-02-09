clc
close all
clear all

%%
load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');


edg_eV = 1560;
b_eV = 851;
e_eV = 931;



S = EELS_sum_spectrum(EELS);
l = EELS.energy_loss_axis';

b = eV2ch(l,b_eV);
e = eV2ch(l,e_eV);

%B = feval(Power_law(l(b:e),S(b:e)),l);
B = feval(Exponential_fit(l(b:e),S(b:e)),l);

[~,iB] = min(abs(B - S(eV2ch(l,edg_eV))));

sh = eV2ch(l,edg_eV) - iB;

shB = circshift(B,sh);



%%

[~,iN] = min(distance_point_curve(edg_eV,S(eV2ch(l,edg_eV)),l,B));

sn = eV2ch(l,edg_eV) - iN;

snB = circshift(B,sn);


%%
plotEELS(l,S)
plotEELS(l,B)
plotEELS(l,shB)
plotEELS(l,snB)
