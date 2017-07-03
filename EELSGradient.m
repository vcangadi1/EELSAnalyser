function EELS = EELSGradient(EELS)
%   INPUT:
%       EELSdata_cube = EELS Spectrum Image (SI) eg: 16 x 16 x 1024
%       e_loss        = (Optional) Calibrated energy-loss axis
%                       If not defined, default is chosen at 1:1:1024
%                       Dispersion = 1eV/channel, Spectrum Offset = 0eV.
%   OUTPUT:
%       EELS_Gradient = Gradient of each spectrum in EELS data cube.

%% 
SI_z = size(EELS.SImage,3);
EELS.Gradient = zeros(size(EELS.SImage));
EELS.Derivative_1 = zeros(size(EELS.SImage));

for i=1:EELS.SI_x,
    for j=1:EELS.SI_y,
        S = squeeze(EELS.SImage(i,j,:));
        for m=1:SI_z-1,
            EELS.Derivative_1(i,j,m) = S(m+1) - S(m);
            dx = EELS.energy_loss_axis(m+1)-EELS.energy_loss_axis(m);
            EELS.Gradient(i,j,m) = (atan(EELS.Derivative_1(i,j,m)).*180/pi);
        end
        EELS.Gradient(i,j,m+1) = EELS.Gradient(i,j,m);
    end
end