clc
clear all

%% Solar cell
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image small disp0.1offset80time0.5s.dm3');
%load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat');
EELS.SImage = EELS.SImage./0.5; %normalise exposure time
%EELS = change_dimension(EELS,90,43);
l = EELS.energy_loss_axis;

EELZ = readEELSdata('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/EELS Spectrum Image disp0.2offset0time0.1s.dm3');
EELZ = change_dimension(EELZ,45,22);
EELZ = change_dispersion(EELZ,EELS.dispersion);
Optional_EELZ_low_loss = EELZ;

%%
[f1, f2, bstar] = Concor2(16.6,15,l,197);

dfcAl = diffCS_L23(13,73,197,bstar,l);
dfcSi = diffCS_L23(14,100,197,bstar,l);
dfcP = diffCS_L23(15,135,197,bstar,l);
Diff_cross_sections = [dfcAl, dfcSi, dfcP];

model_begin_channel = 1;
model_end_channel = eV2ch(l,77);
