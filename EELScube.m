function [EELSdata_cube] = EELScube(EELS_matrix, Number_of_Rows, Number_of_Columns)

% INPUT:
%     EELS_matrix       = Spectrum arranged in 2D. 
%
%                  Rows -> Spectrum (1024 points)
%                Column -> Scanned position/ Individual observations (x*y)
%
%     Number_of_Rows    = Number of rows for Spectrum Image (SI)
%
%     Number_of_Columns = Number of column for Spectrum Image (SI)
%
% OUTPUT:
%     EELSdata_cube     = Spectrum Image data cube (3D) eg: 16 x 16 x 1024
% 
% Spatial Rows & Column -> Probe movement (horz & vert)
%           Z direction -> Spectrum (1024 points)

%%  Convert 3D EELS data cube to 2D EELS matrix
%Length_of_Spectrum=size(EELS_matrix,1);
%EELSdata_cube=zeros(Number_of_Rows,Number_of_Columns,Length_of_Spectrum);
%for i=1:Number_of_Rows,
%    for j=1:Number_of_Columns,
%        EELSdata_cube(i,j,:) = reshape(EELS_matrix(:,(i-1)*Number_of_Columns+j),1,Length_of_Spectrum);
%    end
%end

%% Using matrix operations convert 2-D to 3-D
EELSdata_cube = permute(reshape(EELS_matrix',...
                        Number_of_Columns,...
                        Number_of_Rows,size(EELS_matrix,1)),...
                [2 1 3]);