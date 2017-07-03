function [EELS_matrix] = EELSmatrix(EELSdata_cube)

% INPUT:
%     EELSdata_cube = Spectrum Image data cube (3D) eg: 16 x 16 x 1024
%                Spatial Rows & Column -> Probe movement (horz & vert)
%                          Z direction -> Spectrum (1024 points)
% OUTPUT:
%     EELS_matrix = Spectrum arranged in 2D. 
%                   Rows -> Spectrum (1024 points)
%                 Column -> Scanned position/ Individual observations

%%  If no input argument read the EELS data
if(nargin<1)
    EELSdata_cube = readEELSdata;
end


%%  Convert 3D EELS data cube to 2D EELS matrix
%[Number_of_Rows,Number_of_Columns,Length_of_Spectrum]=size(EELSdata_cube);

%EELS_matrix=reshape(EELSdata_cube(1,:,:),Number_of_Columns,Length_of_Spectrum).';

%if(Number_of_Rows>1)
%    for i=2:Number_of_Rows,
%        EELS_matrix=horzcat(EELS_matrix,reshape(EELSdata_cube(i,:,:),Number_of_Columns,Length_of_Spectrum).');
%    end
%end

%disp(size(EELS_matrix));

%% Use matrix operation to convert from 3-D to 2-D
EELS_matrix = reshape(permute(EELSdata_cube,[3,2,1]),...
    size(EELSdata_cube,3),...
    size(EELSdata_cube,1)*size(EELSdata_cube,2));
