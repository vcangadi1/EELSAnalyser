function [el_X, el_map, el_profile, Q] = auto_back_sub_eels_regions(EELS, delta, coll_angle_mrad, E0_keV, exposure_time_sec, profile_projection)

%EELS = readEELSdata('EELS Spectrum Image 16x16 1s 0.5eV 78offset.dm3');
%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')
%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')

%% Check for all input arguments
if nargin<6
    profile_projection = 0;
end
if nargin<5
    exposure_time_sec = 1;
end
if nargin<4
    E0_keV = 200;
end
if nargin<3
    coll_angle_mrad = EELS.coll_angle_mrad;
end
if nargin<2
    delta = EELS.dispersion;
end
if nargin<1
    error('Insufficient input');
end

EELS.exposure_time_sec = exposure_time_sec;
EELS.E0_keV = E0_keV;
EELS.coll_angle_mrad = coll_angle_mrad;

%% Check for E0_keV and exposure_time_sec
if(~isfield(EELS,'E0_keV'))
    EELS.E0_keV = input('Voltage (E0) keV : ');
end
if(~isfield(EELS,'exposure_time_sec'))
    EELS.exposure_time_sec = input('Exposure time sec : ');
end

%% Arrange energy_loss axis in column vector.
if size(EELS.energy_loss_axis,1) == 1 && size(EELS.energy_loss_axis,2) == EELS.SI_z
    EELS.energy_loss_axis=(EELS.energy_loss_axis)';
end

%% Load look-up table
[Z,elname,eledge,edge_shape,shell] = edge_database('edges_database.xlsx');

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
edge = unique(edge);

disp('Edges considered for quantification: ');
disp(edge');

%% Define pre-edge region for each core-loss edges
pre = [(edge(1)-EELS.energy_loss_axis(1))/2,(diff(edge)'/2)]';
columnname = {'Range_eV'; 'Begin_eV'; 'End_eV'; 'Onset_eV'};
t = table(round(pre),edge-round(pre),edge-2*EELS.dispersion,edge,...
    'VariableNames',columnname);
disp('-------------------------Pre-edge region--------------------------');
disp(t);

%% Define individual regions & extract sum spectrum


