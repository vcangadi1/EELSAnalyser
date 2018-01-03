clc

%% Solar cell
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image disp1offset950time2s.dm3');
load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
EELS.SImage = EELS.SImage./2; %normalise exposure time
EELS = change_dimension(EELS,90,43);
l = EELS.energy_loss_axis;

EELZ = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image disp0.2offset0time0.1s.dm3');
EELZ = change_dimension(EELZ,90,43);
EELZ = change_dispersion(EELZ,EELS.dispersion);
Optional_EELZ_low_loss = EELZ;

[f1, f2, bstar] = Concor2(16.6,15,l,197);

dfcCu = diffCS_L23(29,931,197,bstar,l);
dfcGa = diffCS_L23(31,1115,197,bstar,l);
dfcAs = diffCS_L23(33,1323,197,bstar,l);
Diff_cross_sections = [dfcCu, dfcGa, dfcAs];

model_begin_channel = eV2ch(l,851);
model_end_channel = eV2ch(l,929);
