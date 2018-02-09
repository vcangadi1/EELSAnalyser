clc
%clear all

%load('C:\Users\elp13va.VIE\Documents\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat');
EELS.energy_loss_axis = EELS.energy_loss_axis';


SImage = squeeze(EELS.SImage(89:90,43:44,:));
R = zeros(size(SImage));
r = size(SImage,1);
c = size(SImage,2);


energy_loss_axis = EELS.energy_loss_axis;
ptimer = tic;
%parfor_progress(r*c);
for i = 1:r,
    for j = 1:c,
        R(i,j,:)= edge_fit_detect(SImage,energy_loss_axis,i,j);
%        parfor_progress;
    end
end
%parfor_progress(0);
toc(ptimer);