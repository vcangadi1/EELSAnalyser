clc
clear all

%% Solar cell
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image disp0.5offset250time0.5s.dm3');
load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat');
EELS.SImage = EELS.SImage./0.5; %normalise exposure time
EELS = change_dimension(EELS,90,43);
l = EELS.energy_loss_axis;

EELZ = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image disp0.2offset0time0.1s.dm3');
EELZ = change_dimension(EELZ,90,43);
EELZ = change_dispersion(EELZ,EELS.dispersion);
Optional_EELZ_low_loss = EELZ;

%%
[f1, f2, bstar] = Concor2(16.6,15,l,197);

dfcC = diffCS_K(6,284,197,bstar,l);
dfcIn = diffCS_M45(49,451,197,bstar,l);
dfcO = diffCS_K(8,532,197,bstar,l);
Diff_cross_sections = [dfcC, dfcIn, dfcO];

model_begin_channel = eV2ch(l,200.5);
model_end_channel = eV2ch(l,283);
