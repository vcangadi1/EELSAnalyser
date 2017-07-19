function ch = eV2ch(energy_loss_axis, eV, dim)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       energy_loss_axis - Energy loss axis
%                     eV - Value of eV to which channel number is needed
%                    dim - Matrix dimension
% Output:
%                     ch - Channel number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    dim = 1;
end

if isrow(energy_loss_axis)
    energy_loss_axis = energy_loss_axis';
end


[~,ch] = min(abs(energy_loss_axis - eV), [], dim);