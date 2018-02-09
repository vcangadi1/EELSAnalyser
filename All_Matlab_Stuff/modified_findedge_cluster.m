%{
%function [Smean, Sstd] = modified_findedge_cluster(S, w)
%[eels_edges, EELS_snr] = modified_findedge_cluster(S, l, w)

%[Z,elname,eledge,edge_shape] = edge_database('edges_database_1.xlsx',1,1,21);

%EELS_snr = 0;


S = hampel(S,17);

S = exp(medfilt1(log(abs(S)),10,'truncate'));

S = exp(medfilt1(log(abs(S)),10,'truncate'));


SS = hankel(atan(gradient(S))*180/pi);

SS = SS(1:w,:);

%eels_edges = ((nanstd(SS)'<10) & (nanmean(SS)'>80));

%eels_edges = unique(diff(l(eels_edges))+395);

%for ii = length(eels_edges):-1:1
%    [~,idx(ii)] = min(abs(eledge-eels_edges(ii)));
%end

%eels_edges = unique(eledge(idx));

Smean = nanmean(SS);
Sstd = nanstd(SS);
%}

clear all
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/100kV/EELS Spectrum Image7.dm3'); %Use this (SI 7) instead of 6-b InGaN highloss of Nion machine
load('/Users/veersaysit/Desktop/EELS data/Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat'); %EELS.SImage = EELS.SImage.*repmat(BW,1,1,1024);
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/100kV/EELS Spectrum Image6-b.dm3');
l = EELS.energy_loss_axis;

%%
w = 25;
P = [];
for ii = EELS.SI_x:-1:1
for jj = EELS.SI_y:-1:1
S = squeeze(EELS.SImage(ii,jj,:));
S = exp(medfilt1(log(abs(S)),10,'truncate'));
S = exp(medfilt1(log(abs(S)),10,'truncate'));
SS = hankel(atan(gradient(S))*180/pi);
SS = SS(1:w,:);
Sm(ii,jj,1:1024) = nanmean(SS);
Ss(ii,jj,1:1024) = nanstd(SS);
[~,locs] = findpeaks(nanmean(SS),l,'MinPeakProminence',20,'Annotate','extents');
P = [P; locs];
end
end
%%
figure
histogram(P)
%%
findpeaks(squeeze(mean(mean(Sm,2),1)),l,'MinPeakProminence',20,'Annotate','extents')