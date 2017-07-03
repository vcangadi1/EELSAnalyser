

%% Collect input values
%delta = input('Integration window - Delta (eV) : ');
delta = 15;

%% Load look-up table
[Z,elname,eledge,edge_shape] = edge_database('edges_database.xlsx');

%% Cluster detection

w = 20; % Window size

g = gradient(S);

ang = atan(g)*180/pi;

ang(ang<0) = NaN;

for i = 1:length(S)-w,
    edge(i) = edgedetect(i,i+w,ang);
end

edge = edge(edge>0);

if ~isempty(edge)
    k = 1;
    minE = S(edge(1));
    for i=1:length(edge),
        if(S(edge(i))<=minE)
            E(k) = edge(i);
            minE = S(edge(i));
            k = k+1;
        end
    end

    for i = 1:length(E),
        [~,idx(i)] = min(abs(eledge-EELS.energy_loss_axis(E(i))));
    end

    eels_edges(1:length(eledge(unique(idx),:))) = eledge(unique(idx),:);
else
    eels_edges = NaN;
end
