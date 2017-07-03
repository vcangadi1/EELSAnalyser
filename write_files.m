clc

%%
EELS = readEELSdata('InGaN\60kV\EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);


folderName = 'low_loss';
mkdir(strcat('E:',filesep,folderName,filesep));

for ii = 1:EELS.SI_x
    for jj = 1:EELS.SI_y
    temp = ['ll_',num2str(ii),'_',num2str(jj) '.txt'];
    pathname1 = strcat('E:',filesep,folderName,filesep,temp);

    fid1 = fopen(pathname1, 'w');
    fprintf(fid1, '%f %f\n',[squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:)) EELS.S(ii,jj)]');
    fclose(fid1);
    end
end