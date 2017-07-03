function [I, fig] = spectrum_image(EELS)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input : 
%         EELS - EELS data structure with SImage data cube and dispersion.
% Output: 
%            I - spectrum image. The value of each pixel is the area under
%                the spectrum at that pixel.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Area under the spectrum

I = sum(EELS.SImage,3);
%I = trapz(EELS.energy_loss_axis,EELS.SImage,3);

%% Plot image
if nargout > 1
    fig = figure;
    imagesc(uint64(I),[min(I(:)) max(I(:))]);
    % Retain the original aspect ratio of the image
    axis image
    % Set the axis labels to NIL.
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
end
