function sum_spectrum = EELS_sum_spectrum(EELS,Option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Input:
%       EELS = EELS data structure. The EELS data structure has to be
%              spectrum image (3-D).
%
%   Output:
%       sum_spectrum = All the spectrum summed over the selected region and
%       normalizing it with the total number of spectrum selected.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Area under the curve (Spectrum)
% Display the spectrum image as a single image. Each pixel indicates the
% area under the curve (spectrum). At pixel $(ii,jj)$$, the area under the 
% curve $I(ii,jj)$ is given by,

%% 
% $$ I(ii,jj) = \int_{eV} S(E) dE $$

%%
% Since matlab is brilliant with matrix operations instead of finding area
% one pixel at a time, we can matrixize the operation in more efficient
% way.
%% 
% Calculate the area
I = sum(EELS.SImage,3);

%% Display the image
% Open a temporary _figure_ and display the image with full range to
% include maximum and minimum value of the image.
%%
f = figure;
imagesc(uint64(I),[min(I(:)) max(I(:))]);
% Retain the original aspect ratio of the image
axis image
% Set the axis labels to NIL.
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])

%% Draw the region in image
% Draw a polynomial that describes the region of interest (ROI) in the image. A
% mask will be generated resembling the ROI.
%%
BW = roipoly;

%% Normalized sum spectrum
% All the spectrum that fall withing the mask ROI will be added up and
% normilized to total number of spectrum chosen.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin > 1 && strcmpi(Option,'low_loss')
    temp_EELS = EELS;
    temp_EELS.SImage = EELS.SImage .* repmat(BW,1,1,EELS.SI_z);
    temp_EELS = calibrate_zero_loss_peak(temp_EELS);
    
    C = round(EELSmatrix(temp_EELS.calibrated_energy_loss_axis),2);
    S = EELSmatrix(temp_EELS.SImage);
    
    d = round(temp_EELS.dispersion,2);
    
    ax = min(C(1,:)):d:max(C(end,:));
    
    ax = round(ax,2);
    
    SC = zeros(length(ax),length(C(1,:)));
    
    for ii=1:length(C(1,:))
        ids = find(ax==C(1,ii));
        idl = length(ax)-find(ax==C(end,ii));
        SC(:,ii) = [zeros(1,ids-1),S(:,ii)',zeros(1,idl)];
    end
    
    sum_spectrum = sum(SC,2)./sum(SC>0,2);
    
    ex = length(sum_spectrum)-EELS.SI_z;
    s = floor(ex/10);
    e = length(sum_spectrum)-(ex-s)-1;
    
    sum_spectrum = sum_spectrum(s:e);
else
    sum_spectrum = (squeeze(sum(sum(EELS.SImage .* repmat(BW,1,1,EELS.SI_z),1),2)))/sum(BW(:));
end

%%
% Close the temporary figure
close(f)
