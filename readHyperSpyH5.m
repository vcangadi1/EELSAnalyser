function [data, ax_scales, ax_units, ax_names, ax_sizes, ax_offsets, ax_navigates] = readHyperSpyH5(filename)
%readHyperSpyH5 Read an HDF5 file saved by HyperSpy
%------------------------------------------------------------------
% Input:
%   filename: name of HyperSpy HDF5 file to read
%   
% Output:
%   data: the numerical data contained within the file
%   ax_scales: double array containing the scales of each axis
%   ax_units: cell array containing the units of each axis
%   ax_names: cell array containing the names of each axis
%   ax_size: double array indicated length of each axis
%   ax_offsets:  double array indicating axis offset value
%   ax_navigates: logical array to show if each axis was a nav axis or not


% open low-level h5 file access
fid = H5F.open(filename);

% get name of dataset
info = h5info(filename, '/Experiments');
name = info.Groups.Name;

numAxes = size(info.Groups.Datasets.ChunkSize,2);

ax_scales = zeros(1, numAxes);
ax_units = cell(1, numAxes);
ax_names = cell(1, numAxes);
ax_sizes = zeros(1, numAxes);
ax_offsets = zeros(1, numAxes);
ax_navigates = false(1, numAxes);

% for a 1D [x, y, z, signal] HyperSpy signal, these values all read in
% as [z, y, x, signal]
for i = 1:numAxes
    ax_scales(i) = h5readatt(filename, [name '/axis-' num2str(i-1)], 'scale');
    ax_units{i} = h5readatt(filename, [name '/axis-' num2str(i-1)], 'units');
    ax_names{i} = h5readatt(filename, [name '/axis-' num2str(i-1)], 'name');
    ax_sizes(i) = h5readatt(filename, [name '/axis-' num2str(i-1)], 'size');
    ax_offsets(i) = h5readatt(filename, [name '/axis-' num2str(i-1)], 'offset');
    % For some reason, h5readatt doesn't work on navigate, which is ENUM
    % datatype, so use low-level functions instead
    %   navigates{i} = h5readatt(filename, [name '/axis-' num2str(i-1)], 'navigate');
    gid = H5G.open(fid, [name '/axis-' num2str(i-1)]);
    attr_id = H5A.open(gid, 'navigate');
    ax_navigates(i) = H5A.read(attr_id);
    H5A.close(attr_id);
    H5G.close(gid);
end

% shift the arrays so they're in [x, y, z, ..., signal] order
ax_scales = circshift(flip(ax_scales),[0,-1]);
ax_units = circshift(flip(ax_units),[0,-1]);
ax_names = circshift(flip(ax_names),[0,-1]);
ax_sizes = circshift(flip(ax_sizes),[0,-1]);
ax_offsets = circshift(flip(ax_offsets),[0,-1]);
ax_navigates = circshift(flip(ax_navigates),[0,-1]);

% read actual data
% for a 1D [x, y, z, signal] HyperSpy signal, this data is read 
% as shape [signal, x, y, z]
data = h5read(filename, [name '/data']);

% shift dimensions of data to put in [x, y, z, signal] order (like in HyperSpy)
data = shiftdim(data, 1);

% close low-level file access
H5F.close(fid);

end