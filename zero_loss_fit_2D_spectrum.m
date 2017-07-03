clc

EELS = readEELSdata('C:\Users\elp13va.VIE\Desktop\EELS data\GaAs100_Q4_EELStest_130705\Pos1_20muCA\EELS_0.6mm_0.1s.dm3');

l = (1:EELS.Image_y)'*0.05024;
S = sum(EELS.Image)';
l = calibrate_zero_loss_peak(l,S);

for ii = 200:-1:20
    l = calibrate_zero_loss_peak(l,EELS.Image(ii,:)');
    [W(ii),E(ii),A(ii),G] = zero_loss_fit(l,EELS.Image(ii,:)');
    el(ii,1:1024) = l;
    I(ii,:) = A(ii)*G(l,E(ii),W(ii));
    fprintf('%d',ii);
end 

