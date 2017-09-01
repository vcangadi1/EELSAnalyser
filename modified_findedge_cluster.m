
function [eels_edges, EELS_snr] = modified_findedge_cluster(S, l, w)

[Z,elname,eledge,edge_shape] = edge_database('edges_database_1.xlsx',1,1,21);

EELS_snr = 0;


S = hampel(S,17);

S = exp(medfilt1(log(abs(S)),10,'truncate'));

S = exp(medfilt1(log(abs(S)),10,'truncate'));


SS = hankel(atan(gradient(S))*180/pi);

SS = SS(1:w,:);

eels_edges = ((nanstd(SS)'<w) & (nanmean(SS)'>80));

eels_edges = unique(diff(l(eels_edges))+395);

for ii = length(eels_edges):-1:1
    [~,idx(ii)] = min(abs(eledge-eels_edges(ii)));
end

eels_edges = unique(eledge(idx));