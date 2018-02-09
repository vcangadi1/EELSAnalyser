clc

si_struct = DM3Import( 'C:\Users\elp13va.VIE\Dropbox\MATLAB\InGaAs_Vn1061_230315\EELS Spectrum Image 2 Scan 69x2 pixels15.3nm 5s.dm3' );

x = zeros(1024,1);
for i=6:69,
EELS_spectrum = si_struct.image_data(1,i,:);
disp(i);
EELS_spectrum = reshape(EELS_spectrum,1,1024).';
figure(1)
%hold on
plot((1:1024)+480,EELS_spectrum);
x = x+EELS_spectrum;
figure(2)
%hold on
plot((1:1024)+480,x)
end
