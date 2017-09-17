function [pixel, BW] = EELS_pixel(Image,Option,BW,plot_enable)
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

if nargin < 4
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
if nargin < 3
    BW = roipoly;
end

if size(BW,1) ~= size(Image,1) && size(BW,2) ~= size(Image,2)
    error('Size of BW and Image must be same');
end

%% Normalized sum pixel
% All the spectrum that fall withing the mask ROI will be added up and
% normilized to total number of spectrum chosen.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch Option
    case {'avg','Avg','average','mean'}
        pix = sum(sum(Image.*BW))./numel(BW(BW>0));
        if nargout > 0
            pixel = pix;
        end
        fprintf('Mean = %f\n',pix);
    case {'std'}
        p = Image.*BW;
        p = p(p~=0);
        pix = std(p(:));
        if nargout > 0
            pixel = pix;
        end
        fprintf('Std = %f\n',pix);
    case {'sum','Sum','Summation'}
        pix = sum(sum(Image.*BW));
        if nargout > 0
            pixel = pix;
        end
        fprintf('Sum = %f\n',pix);
    case {'med','median','Median'}
        p = Image.*BW;
        p = p(p~=0);
        pix = median(p(:));
        if nargout > 0
            pixel = pix;
        end
        fprintf('Median = %f\n',pix);
    case {'stat','stats'}
        pix(1) = sum(sum(Image.*BW))./numel(BW(BW>0));
        p = Image.*BW;
        p = p(p~=0);
        pix(2) = std(p(:));
        if nargout > 0
            pixel(:) = pix(:);
        end
        fprintf('Mean = %f\t Std = %f\n',pix(1),pix(2));
    case {'nanstat'}
        pix(1) = nansum(nansum(Image.*BW))./numel(BW(BW>0));
        p = Image.*BW;
        p = p(p~=0);
        pix(2) = nanstd(p(:));
        if nargout > 0
            pixel(:) = pix(:);
        end
        fprintf('Mean = %f\t Std = %f\n',pix(1),pix(2));
end

%%
% Close the temporary figure
if f~=0
    close(f)
end
