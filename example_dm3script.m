   %%%%%% EXAMPLE OF DM3IMPORT WITH AN IMAGE %%%%%%%
   
% Example, loading an image that is in the path or working directory, note 
% that the '.dm3' extension is optional.
image_struct = DM3Import( 'DMimage' );

disp( image_struct ) % Show the fields of the structure

% The data is extremely easy to access, but for display purposes we often
% want to dig into the structure and build scale bars for our plots

% Let's build an xy-axis for display purposes
% Get size of image in pixels
image1 = image_struct.image_data .* image_struct.intensity.scale; % Scale from counts to electrons
N = length( image1 ); 
% Get pixel size (in nm)
ps = image_struct.xaxis.scale;
xyscale = (0:N-1).*ps;

% Then display the image, with autoscaling
fig1 = figure; movegui;
set(fig1,'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12, 'DefaultAxesFontWeight', 'Demi' );
imagesc( xyscale, xyscale, image1 );
title( 'An example electron hologram imported into MATLAB' );
xlabel( 'Scale (nm)' );
colorbar;
% Print an encapsulated postscript file to disk, suitable for publication
print(fig1,'-deps2', 'dm3image.eps' )



   %%%%%% EXAMPLE OF DM3IMPORT WITH A HITACHI TAGS AND ANNOTATIONS %%%%%%%
hitachi_struct = DM3Import( 'HitachiTagTest2.dm3' );
disp( hitachi_struct.image_text )
disp( hitachi_struct.Hitachi )



   %%%%%% EXAMPLE OF DM3IMPORT WITH A SPECTRA %%%%%%%
spectra_struct = DM3Import( 'DMspectra.dm3' );
disp( spectra_struct ) % Show the fields of the structure

% There are two seperate spectra in this file, so we can reference each
% individually within the cell array
spectra1 = spectra_struct.spectra_data{1} .* spectra_struct.intensity.scale;
spectra2 = spectra_struct.spectra_data{2} .* spectra_struct.intensity.scale;

N1 = length( spectra1 );
dispersion1 = spectra_struct.xaxis{1}.scale;
origin1 = spectra_struct.xaxis{1}.origin;
escale1 =  ( (0:N1-1)-origin1 ) .* dispersion1;

N2 = length( spectra2 );
dispersion2 = spectra_struct.xaxis{2}.scale;
origin2 = spectra_struct.xaxis{2}.origin;
escale2 = ( (0:N2-1)-origin2 ) .* dispersion2;

% Create our own set of colours for plotting
plotcol = [ [1 0 0]; [0 0 1]; [0 0.67 0]; [1 0.5 0.0]; [0 0 0]; ];

fig2 = figure; movegui;
set(fig2, 'DefaultAxesColorOrder', plotcol )
set(fig2,'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12, 'DefaultAxesFontWeight', 'Demi' );
plot( escale1, spectra1, 'r', escale2, spectra2, 'b', 'LineWidth', 2.5 );
legend( 'Spectrum 1', 'Spectrum 2' );
title( 'An example pair of EELS spectra imported into MATLAB' );
xlabel( 'Dispersion (eV)' );
ylim( [0 40000] ); % Limit display to 40,000 electrons
ylabel( 'Counts (e^-)' );
% Print an encapsulated postscript file to disk, suitable for publication
print(fig2,'-deps2', 'dm3spectra.eps' )



   %%%%%% EXAMPLE OF DM3IMPORT WITH A SPECTRAL IMAGE %%%%%%%
   % Example is a low-dose spectral image. 
   % We want to subtract the power-law background background from each
   % spectra pixel and then display the image, along with an example
   % spectrum.  

si_struct = DM3Import( 'DMspectraimage.dm3' );

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
for I = 1:K
    for J = 1:L
        ex_spectrum = si_struct.image_data( I, J, : ); % the spectrum at pixel (1,1)
        % Reshape the array so it's in 2-D instead of 3-D
        ex_spectrum = reshape( ex_spectrum, 1, N3);
        % Apply a 10-point moving average smoothing filter to the spectrum
        ex_spectrum = smooth( ex_spectrum, 10 );

        % At this point, you need a MATLAB toolbox, i.e. the curve fitting toolbox, to remove the background
        % Fit a power-law to the first 1/4 of the spectrum (don't use the energy
        % scale here, just give it integers for the x-axis).
        if( exist( 'fit' ) == 2 ) % Check to see if we have the fit function
            fit_spec = fit( (1:N3/4).', ex_spectrum(1:N3/4), 'power2' );
            % Subtract the fit from the spectrum
            ex_spectrum = ex_spectrum - feval( fit_spec, 1:N3);
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
    plot( escale3, reshape( si_struct.image_corr(1,1,:), 1, 1024), ...
        escale3, reshape( si_struct.image_corr(9,7,:), 1, 1024), ...
        escale3, reshape( si_struct.image_corr(18,14,:), 1, 1024) );
    xlabel( 'Energy loss (eV)' );
    ylabel( 'Counts' );
    title( 'Example spectra from the spectral image' );
    legend( 'Pixel (1,1)', 'Pixel (9,7)', 'Pixel (18,14)' );
    saveas( gcf, 'si_example', 'fig' );
else % You don't have the curve-fitting toolbox
    % Plot the saved figures
    open( 'si_image.fig' );
    open( 'si_example.fig' );
end





