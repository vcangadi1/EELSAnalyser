clc

load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')

EELS = calibrate_zero_loss_peak(EELS);

C = round(EELSmatrix(EELS.calibrated_energy_loss_axis),2);
S = EELSmatrix(EELS.SImage);

d = round(mean(diff(C(:,1))),2);

ax = min(C(1,:)):d:max(C(end,:));

ax = round(ax,2);

SC = zeros(length(ax),length(C(1,:)));
for ii=1:length(C(1,:)),
    ids = find(ax==C(1,ii));
    idl = length(ax)-find(ax==C(end,ii));
    SC(:,ii) = [zeros(1,ids-1),S(:,ii)',zeros(1,idl)];
end

denom2 = sum(SC>0,2);

Sp = sum(SC,2)./sum(SC>0,2);