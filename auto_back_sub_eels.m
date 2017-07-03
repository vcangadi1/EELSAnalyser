function [el_X, el_map, el_profile, Q] = auto_back_sub_eels(EELS, delta, coll_angle_mrad, E0_keV, exposure_time_sec, profile_projection)

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

%% Define individual edges
Q = zeros(length(edge),EELS.SI_x,EELS.SI_y,EELS.SI_z);

e_idx = zeros(size(edge))';

for i=1:EELS.SI_x,
    for j=1:EELS.SI_y,
        for k = 1:length(edge),
            [~,e_idx(k)] = min(abs(EELS.energy_loss_axis-edge(k)));
            f = Power_law(EELS.energy_loss_axis(e_idx(k)-round(pre(k)/EELS.dispersion):e_idx(k)-round(2*EELS.dispersion)),...
                        squeeze(EELS.SImage(i,j,e_idx(k)-round(pre(k)/EELS.dispersion):e_idx(k)-round(2*EELS.dispersion))));
            Q(k,i,j,:) = [squeeze(EELS.SImage(i,j,1:e_idx(k)-1));f(EELS.energy_loss_axis(e_idx(k):end))];
        end
    end
end

%% Map each edges
elname_idx = zeros(size(edge));
for i = 1:length(edge),
    [~,elname_idx(i)] = min(abs(eledge-edge(i)));
end

dlt = zeros(size(edge));
el_map = zeros(length(edge),EELS.SI_x,EELS.SI_y);
el_X = zeros(length(edge),EELS.SI_x,EELS.SI_y);
Sig = zeros(size(edge));

for i=1:length(edge),
    % Integrate extracted edges
    el = EELS.SImage-squeeze(Q(i,:,:,:));
    if(strcmp(edge_shape(elname_idx(i)),'d'))
        if(i == length(edge))
            dlt(i) = EELS.energy_loss_axis(end)-edge(i);
            el_map(i,:,:) = sum(el(:,:,e_idx(i):end),3);
        else
            dlt(i) = edge(i+1)-edge(i);
            el_map(i,:,:) = sum(el(:,:,e_idx(i):e_idx(i+1)),3);
        end
    else
        dlt(i) = delta;
        el_map(i,:,:) = sum(el(:,:,e_idx(i):e_idx(i)+round(delta/EELS.dispersion)),3);
    end
    %imshow(uint64(squeeze(el_map(i,:,:))),[min(min(abs(el_map(i,:,:)))) max(max(el_map(i,:,:)))])
    %title([elname(elname_idx(i));' (',num2str(edge(i)),'eV)']);
    %colorbar
    %colormap('parula')
    
    % Quantify edges X = I/(Sig*exposure_time)
    if(strcmp(shell(elname_idx(i)),'K'))
        Sig(i) = Sigmak3(Z(elname_idx(i)),eledge(elname_idx(i)),dlt(i),EELS.E0_keV,EELS.coll_angle_mrad);
        el_X(i,:,:) = squeeze(el_map(i,:,:))./(Sig(i)*EELS.exposure_time_sec);
    elseif(strcmp(shell(elname_idx(i)),'L'))
        Sig(i) = Sigmal3(Z(elname_idx(i)),dlt(i),EELS.E0_keV,EELS.coll_angle_mrad);
        el_X(i,:,:) = squeeze(el_map(i,:,:))./(Sig(i)*EELS.exposure_time_sec);
    else
        if(dlt(i)>=250)
            dlt(i)=249;
            fprintf('The delta for M-edge is capped to %d eV\n', dlt(i));
        end
        Sig(i) = Sigpar(Z(elname_idx(i)),dlt(i),char(shell(elname_idx(i))),EELS.E0_keV,EELS.coll_angle_mrad)/(10^-24);
        el_X(i,:,:) = squeeze(el_map(i,:,:))./(Sig(i)*EELS.exposure_time_sec);
    end

    % Extract profiles of individual elements
    el_profile(:,i) = profile_extract(squeeze(el_X(i,:,:)),profile_projection);
end

for i=1:length(edge),
    % Map all elements
    figure (2);
    %subplot(ceil(sqrt(length(edge))),ceil(sqrt(length(edge))),i)
    subplot(1,length(edge),i)
    %el_X(el_X<0) = 0;
    el_map(el_map<0) = 0;
    %el_X(isnan(el_X(:)))=0;
    el_map(isnan(el_map(:)))=0;
    %imagesc(squeeze(el_X(i,:,:)));
    imagesc(squeeze(el_map(i,:,:)));
    title([elname(elname_idx(i));' (',num2str(edge(i)),'eV)']);
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    %c = colorbar;
    %c.Label.String = 'x';
    %c.Label.FontSize = 13.2;
    %c.FontWeight = 'bold';
    %c.FontSize = 12;
    %caxis([min(el_X(:)) max(el_X(:))]);
    colormap('parula')
    
    % Plot profiles
    figure (3);
    subplot(length(edge),1,i)
    plot(el_profile(:,i),'LineWidth',2)
    axis([1 length(squeeze(el_profile(:,i))) 0 ceil(max(el_profile(:)))]);
    xlabel('Profile','FontWeight','bold');
    ylabel('Concentration (X)','FontWeight','bold');
    legend(elname(elname_idx(i)),'FontSize',10,'FontWeight','bold','Location','northwest')
    legend('boxoff')
end

%% Intergration range
columnname = {'Onset_eV'; 'Element'; 'Begin_eV'; 'End_eV'; 'Integration_Range_eV'};
t = table(eledge(elname_idx),elname(elname_idx),edge,edge+dlt,dlt,...
    'VariableNames',columnname);
disp('-------------------------Integration region--------------------------');
disp(t);