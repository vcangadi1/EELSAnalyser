clc
clear all
%% Solar cell
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/100kV/EELS Spectrum Image6-b.dm3');
%EELS = change_dimension(EELS,90,43);
Energy_shift = 7;
EELS.energy_loss_axis = EELS.energy_loss_axis + Energy_shift;
l = EELS.energy_loss_axis + Energy_shift;

EELZ = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/100kV/EELS Spectrum Image6-thickness-map.dm3');
%EELZ = change_dimension(EELZ,90,43);
EELZ = change_dispersion(EELZ,EELS.dispersion);
Optional_EELZ_low_loss = EELZ;

%%
bstar = 45;
%[f1, f2, bstar] = Concor2(16.6,15,l,197);

dfcIn = diffCS_M45(49,443,100,bstar,l);
dfcGa = diffCS_L23(31,1115,100,bstar,l);
dfcN = diffCS_K(7,400,100,bstar,l);
Diff_cross_sections = [dfcN, dfcIn, dfcGa];

%%
model_begin_channel = 1;
model_end_channel = eV2ch(l,397);
