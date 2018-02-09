function E = create_ionization_edge(edge_onset_channel , edge_height, edge_damping, energy_loss_axis)

% The largest peak of the low-loss spectrum is considered as the ZLP.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%  edge_onset_channel - The channel number of the edge onset
%         edge_height - Height of the ionization edge
%        edge_damping - decay factor of the edge. Ranges from 0 to 1
%    energy_loss_axis - (Optional) Energy-loss axis
% Output: 
%                   E - Simulated edge. (Artificial edge)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check if the energy-loss-axis is presented by the user
% If the energy-loss axis is not provided by the user then use a default 
% value. _Channels = 1024_ and _Dispersion = 1eV/channel_.

%%
if nargin<4
    l = (1:1024)';
else
    l = energy_loss_axis;
end

%% Create ionization edge
% * Assign value _edge_height_ to the next channel of _edge_onset_channel_.
% * Use inverse power-law to decay the ionization edge onset to a value of
% _edge_height*edge_damping_.

%%
% Pre-allocate zeros to output variable _E_
E = zeros(size(l));
% Assign the height of the edge
E(edge_onset_channel+1) = edge_height;
% Use inverse power-law to decay the ionization edge.
x = [l(edge_onset_channel+1),l(end)];
y = [E(edge_onset_channel+1),edge_height*edge_damping];
slp = feval(Power_law(x,y),l(edge_onset_channel+1:end));
% Concatenate the edge onset and the inverse power-law decay to give _E_
E =[E(1:edge_onset_channel); slp];
