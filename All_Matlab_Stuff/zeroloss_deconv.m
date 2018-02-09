clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 32x32 0.1s 0.5eV 0offset' );
EELS_spectrum = si_struct.image_data(1,1,:);
D = si_struct.zaxis.scale;
N = size(si_struct.image_data,3);
EELS_spectrum = reshape(EELS_spectrum,1,N).';

EELS = smooth(EELS_spectrum);

z = [EELS_spectrum(1:310); ones(512-310,1)*EELS_spectrum(1)];

z = smooth(z,10);

plot(z);