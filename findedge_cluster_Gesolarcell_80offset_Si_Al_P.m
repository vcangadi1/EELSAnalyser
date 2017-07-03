clc

[NA,elname,eledge,edge_shape] = edge_database('edges_database.xlsx');

%EELS = readEELSdata('EELS Spectrum Image 16x16 1s 0.5eV 78offset.dm3');
%EELS.energy_loss_axis = EELS.energy_loss_axis-5;

%load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
%load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

I = squeeze(EELS.SImage(:,:,1));
I(I(:)<2000) = 0;
I(I(:)>=2000) = 1;
EELS.SImage = EELS.SImage .* repmat(I,1,1,EELS.SI_z);

plotEELS(EELS);
w = 10;

for m = 1:EELS.SI_x,
    for n = 1:EELS.SI_y,

S = squeeze(EELS.SImage(m,n,:));

S = exp(medfilt1(log(S),10,'truncate'));
S = exp(medfilt1(log(S),10,'truncate'));

plot(EELS.energy_loss_axis,S);

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


eels_edges(m,n,1:length(eledge(unique(idx),:))) = eledge(unique(idx),:);

else
    eels_edges(m,n,:)=NaN;
end

    end
end

nbins = 100;
eels_edges(eels_edges(:)<EELS.energy_loss_axis(1)) = NaN;
e = EELSmatrix(eels_edges);
h = histogram(reshape(e,1,size(e,1)*size(e,2)),nbins);
%disp(elname(unique(idx),:))
%disp(eledge(unique(idx),:))
t = table(NA,elname,eledge,edge_shape);
disp(t)