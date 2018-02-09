fprintf(1,'\n--------------- Curve fit--------------\n\n');

%   Read spectrum from input file
si_struct = DM3Import( 'EELS Spectrum Image 16x16 0.2s 0.3eV 0offset' );
display(si_struct);

%   Read length of the Spectrum
N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);

%   Read Image dimentions
r = size(si_struct.image_data,1);
c = size(si_struct.image_data,2);
fprintf('\nImage dimentions : %d X %d\n',r,c);

%   Read Dispersion of the spectrum
D = si_struct.zaxis.scale;
fprintf('\nDispersion : %.2f\n',D);

%   Read the actual Origin of the Spectrum
Origin = si_struct.zaxis.origin;
fprintf('\nOrigin : %d\n',Origin);

EELS_spectrum = si_struct.image_data(8,4,:);
EELS_spectrum = (reshape(EELS_spectrum,N,1));

plot(EELS_spectrum,'LineWidth',3)

for i=1:N-1,
    ds(i) = (EELS_spectrum(i)-EELS_spectrum(i+1));
end

maxS = max(EELS_spectrum);
for i=1:N,
    if(EELS_spectrum(i) == maxS)
        org = i;
        break;
    end
end

N = size((org:N),2);
for i=org:N,
    EELS(i-org+1)=(EELS_spectrum(i)).';
end
EELS = reshape(EELS,N,1);

hold on
plot(ds,'r','LineWidth',3)
hold off