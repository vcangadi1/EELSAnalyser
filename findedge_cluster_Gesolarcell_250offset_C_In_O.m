clc

[NA,elname,eledge,edge_shape] = edge_database('edges_database.xlsx');

%EELS = readEELSdata('EELS Spectrum Image 16x16 1s 0.5eV 78offset.dm3');
load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')

%EELS.energy_loss_axis = EELS.energy_loss_axis-5;

S = squeeze(EELS.SImage(90,44,:));
plot(EELS.energy_loss_axis,S);
hold on

%lS = log(S);
S = exp(medfilt1(log(S),10,'truncate'));
S = exp(medfilt1(log(S),10,'truncate'));

plot(EELS.energy_loss_axis,S);

g = gradient(S);

ang = atan(g)*180/pi;

ang(ang<0) = NaN;

plot(EELS.energy_loss_axis,ang)
hold off

w = 15;

for i = 1:length(S)-w,
    edge(i) = edgedetect(i,i+w,ang);
end
edge = edge(edge>0);

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

disp(elname(unique(idx),:))
disp(eledge(unique(idx),:))
t = table(NA,elname,eledge,edge_shape);
disp(t)