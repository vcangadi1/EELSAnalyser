function plot_all_spectra(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots all the spectrum of every pixel ofthe image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Nlines Nsamples Nbands data wavelength_unit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(data)
    disp('Error : no image loaded.');
    return;
else
    figure
    plot(reshape(data,Nsamples*Nlines,Nbands)')
    xlabel('Wavelength')
    ylabel('Amplitude')
    title('Image spectra')
    unit = strcat('Unit : ', wavelength_unit);
    % Création de l'objet Uicontrol text file
    handles_local = uicontrol('style','text',...
        'units','normalized',...
        'position',[0.0 0.0 0.2 0.035],...
        'tag','file',...
        'string',unit,...
        'foregroundcolor',[0 0 0]);                
end

end

