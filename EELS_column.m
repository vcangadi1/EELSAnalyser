clc
close all

EELS=readEELSdata('Si B P 10082015/EELS Spectrum Image 25nm.dm3');

%EELS = PCA_denoise(EELS);

i = input('Enter column number : ');

E_mid = reshape(sum(EELS.SImage(:,i,:)),1,EELS.SI_z);

E_left = reshape(sum(EELS.SImage(:,i-1,:)),1,EELS.SI_z);

E_right = reshape(sum(EELS.SImage(:,i+1,:)),1,EELS.SI_z);

Eavg = (E_left+E_right)/2;

plot(EELS.energy_loss_axis,E_mid);
hold on
plot(EELS.energy_loss_axis,Eavg);
plot(EELS.energy_loss_axis,E_mid-Eavg);
%plot(EELS.energy_loss_axis,E_left);
%plot(EELS.energy_loss_axis,E_right);
xlabel('Energy-loss axis (eV)')
ylabel('count')
%legend('Emid','Eleft','Eright');
legend('Emid','Eavg','residue');