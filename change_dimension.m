function rEELS = change_dimension(EELS, new_row, new_col)

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%         EELS        - EELS structure
%          new_row    - expected number of rows
%          new_col    - expected number of columns
% Output:
%         rEELS       - resize EELS structure

%%

rEELS = EELS;

rEELS.SI_x = new_row;
rEELS.SI_y = new_col;

rEELS.SImage = zeros(rEELS.SI_x, rEELS.SI_y, EELS.SI_z);

for ii = EELS.SI_z:-1:1
    rEELS.SImage(:,:,ii) = imresize(squeeze(EELS.SImage(:,:,ii)),[new_row,new_col]);
end

%%
rEELS.step_size.x = EELS.step_size.x*EELS.SI_x/new_row;
rEELS.step_size.y = EELS.step_size.y*EELS.SI_y/new_col;

%%
clc;
fprintf('dimension is changed to (%d,%d)\n', rEELS.SI_x,rEELS.SI_y);
strucdisp(rEELS)