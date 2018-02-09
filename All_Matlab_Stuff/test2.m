close all;
clear all;
clc
   %%%%%% EXAMPLE OF DM3IMPORT WITH A SPECTRAL IMAGE %%%%%%%
   % Example is a low-dose spectral image.
   % We want to subtract the power-law background background from each
   % spectra pixel and then display the image, along with an example
   % spectrum.
si_struct = DM3Import( 'EELS Spectrum Image 16x16 0.2s 0.3eV 0offset' );
%%
disp( si_struct ) % Show the fields of the structure
N3 = length( si_struct.image_data ); % Individual spectrum length
K = size( si_struct.image_data, 1 );
L = size(si_struct.image_data, 2);

dispersion3 = si_struct.zaxis.scale;
origin3 = si_struct.zaxis.origin;
escale3 =  ( (0:N3-1)-origin3 ) .* dispersion3;

% Make a nested for loop to process all the spectra
% Create a fresh array for the background corrected spectra
si_struct.image_corr = zeros( size( si_struct.image_data ) );
% and another array for
si_struct.siimage = zeros( [K L] );
si_struct.imageio = zeros( [K L] );
for I = 1:K
    for J = 1:L
        ex_spectrum = si_struct.image_data( I, J, : ); % the spectrum at pixel (1,1)
        % Reshape the array so it's in 2-D instead of 3-D
        ex_spectrum = reshape( ex_spectrum, 1, N3);
        % Apply a 10-point moving average smoothing filter to the spectrum
        ex_spectrum = smooth( ex_spectrum, 10 );
        si_struct.imageio = sum( ex_spectrum);
        % At this point, you need a MATLAB toolbox, i.e. the curve fitting toolbox, to remove the background
        % Fit a power-law to the first 1/4 of the spectrum (don't use the energy
        % scale here, just give it integers for the x-axis).
        if( exist( 'fit' ) == 2 ) % Check to see if we have the fit function
            fit_spec = fit( (1:N3).', ex_spectrum(1:N3), 'power2' );
            % Subtract the fit from the spectrum
            ex_spectrum = abs(ex_spectrum - feval( fit_spec, 1:N3));
            % Drop it back into the corrected array
            si_struct.image_corr(I,J,:) = ex_spectrum;
            % Simple integration of the background corrected spectrum and make it a pixel
            % in the spectral image
            si_struct.siimage(I,J) = sum( ex_spectrum );
        end
    end
end

if( exist( 'fit' ) == 2 ) % You have the curve-fitting toolbox
    figure; movegui;
    imagesc( si_struct.siimage );
    axis image;
    title( 'Simple integrated, background subtracted spectral image' );
    saveas( gcf, 'si_image', 'fig' );
    
    % Plot some example spectra
    % From this we can see that the zero-loss was wandering over the course of
    % the acquisition.  So that's a source of error in our spectral image
    % result.  Fixing that is a little beyond the scope of this example of
    % using DM3Import.
    figure; movegui;
    %for i=1:16,
      %  for j=1:16,
       %     plot(0:N3-1, reshape( si_struct.image_corr(i,j,:), 1, 1024));
        %    hold on;
       % end
    %end
    %hold off;
    plot( 0:N3-1, 10*log(reshape( si_struct.image_corr(1,1,:), 1, 1024)), ...
        0:N3-1, reshape( si_struct.image_corr(9,7,:), 1,1024), ...
        0:N3-1, reshape( si_struct.image_corr(16,14,:), 1, 1024));
    grid on;
    xlabel( 'Energy loss (eV)' );
    ylabel( 'Counts' );
    title( 'Example spectra from the spectral image :  16x16 0.2s 0.3eV 0offset' );
    legend( 'Pixel (1,1)', 'Pixel (9,7)', 'Pixel (16,14)' );
    saveas( gcf, 'si_example', 'fig' );
else % You don't have the curve-fitting toolbox
    % Plot the saved figures
    open( 'si_image.fig' );
    open( 'si_example.fig' );
end