clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' )

N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);

m = size(si_struct.image_data,1);
n = size(si_struct.image_data,2);
fprintf('\nSize of Image (m,n) : (%d,%d)\n',m,n);

D = si_struct.zaxis.scale;
fprintf('\nDispersion : %.2f\n',D);

Origin = si_struct.zaxis.origin;
fprintf('\nOrigin : %d\n',Origin);

Scale = ((0:N-1)-Origin-31).* D;

image_corr = zeros(size(si_struct.image_data));

siimage = zeros([m,n]);
imageio = zeros([m,n]);

k = 0;
for i = 1:16,
    for j = 1:16,
        EELS_spectrum = si_struct.image_data(i,j,:);
        EELS_spectrum = reshape(EELS_spectrum,1,N);
    end;
end

sp = zeros([1024,2]);
sp(:,1) = 1:1024;
sp(:,2) = EELS_spectrum;

sp(1:130,1) = 0;
sp(1:130,2) = 0;

sp(131:1024,1) = sp(131:1024,1) - 131;
spectrum = zeros(size(sp));
spectrum(1:1024-130,1) = sp(131:1024,1);
spectrum(1:1024-130,2) = sp(131:1024,2);

b = robustfit(Scale, EELS_spectrum)
plot(spectrum(:,1),spectrum(:,2),'.')

