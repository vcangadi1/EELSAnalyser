function [Edge_onset_eV, Pre_edge_range, Pre_edge_begin, Pre_edge_end] = detect_edges_gradient(EELS, delta)



%% Check for all input arguments
if nargin<1
    error('Insufficient input');
end
if nargin<2
    delta = input('Integration range (eV) - delta : ');
end

%% Arrange energy_loss axis in column vector.
if size(EELS.energy_loss_axis,1) == 1 && size(EELS.energy_loss_axis,2) == EELS.SI_z
    EELS.energy_loss_axis=(EELS.energy_loss_axis)';
end

%% Call findedge_cluster function
eels_edges = findedge_cluster(EELS);

eels_edges(isnan(eels_edges))=0;
edge = unique(eels_edges);
edge= edge(2:end);                  % find uneque edges in EELS

disp('Detected edges : ');
disp(edge')

%% Check whether delta overlaps wth next core-loss edge
for i = 1:length(edge)-1,
    if(edge(i+1)<delta+edge(i))
        disp(['Delta is overlapping with next edge. Edge ',num2str(edge(i+1)),'eV is omitted']);
        edge(i+1)=edge(i);
    end
    if(edge(i+1)+delta>EELS.energy_loss_axis(end))
        disp(['Delta for edge ',num2str(edge(i+1)),'eV is exceeding energy-loss axis limit (',num2str(EELS.energy_loss_axis(end)),'eV)']);
        edge(i+1)=edge(i);
    end
end
Edge_onset_eV = unique(edge);

disp('Edges considered for quantification: ');
disp(Edge_onset_eV');

%% Define pre-edge region for each core-loss edges
pre = [(Edge_onset_eV(1)-EELS.energy_loss_axis(1))/2,(diff(Edge_onset_eV)'/2)]';
Pre_edge_range = round(pre);
Pre_edge_begin = Edge_onset_eV - Pre_edge_range;
Pre_edge_end = Edge_onset_eV-2*EELS.dispersion;

columnname = {'Onset_eV'; 'Range_eV'; 'Begin_eV'; 'End_eV'; };
t = table(Edge_onset_eV, Pre_edge_range, Pre_edge_begin, Pre_edge_end,...
    'VariableNames',columnname);
disp('-------------------------Pre-edge region--------------------------');
disp(t);