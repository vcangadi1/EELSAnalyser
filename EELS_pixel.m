function [pixel, BW] = EELS_pixel(Image,Option,plot_enable)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Input:
%        Image = Any 2-D image
%       Option = 'avg', 'mean', 'sum', 'median'
%
%   Output:
%        pixel = All the pixels summed over the selected region awith an
%       option of normalizing it with the total number of pixels selected.
%           BW = Binary mask or region of interest (ROI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    Option = 'avg';
end

if nargin < 3
    plot_enable = 0;
end

f = 0;
%%
if plot_enable ~= 0
    f = figure;
    I = Image;
    imagesc(uint64(I),[min(I(:)) max(I(:))]);
    colormap gray
    % Retain the original aspect ratio of the image
    axis image
    % Set the axis labels to NIL.
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
end
%% Draw the region in image
% Draw a polynomial that describes the region of interest (ROI) in the image. A
% mask will be generated resembling the ROI.
%%
BW = roipoly;

%% Normalized sum pixel
% All the spectrum that fall withing the mask ROI will be added up and
% normilized to total number of spectrum chosen.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch Option
    case {'avg','Avg','average','mean'}
        pixel = sum(sum(Image.*BW))./sum(BW(:));
    case {'std'}
        p = Image.*BW;
        p = p(p~=0);
        pixel = std(p(:));
    case {'sum','Sum','Summation'}
        pixel = sum(sum(Image.*BW));
    case {'med','median','Median'}
        p = Image.*BW;
        p = p(p~=0);
        pixel = median(p(:));
end

%%
% Close the temporary figure
if f~=0
    close(f)
end
