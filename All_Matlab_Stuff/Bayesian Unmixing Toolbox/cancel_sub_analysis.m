function cancel_sub_analysis(obj,event)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global data Nlines Nsamples Nbands wavelength_unit interleave offset byte_order data_type wavelength handles FileName PathName RGB
    
if isempty(data)
    disp('Error : no file loaded');
    return;
else
    %Reload the entire image, reset the values of the parameters
    Filename = strcat(FileName, '.hdr'); %nom du fichier header dont les paramètres utiles sont extraits
    [Nsamples, Nlines, Nbands, interleave, offset, byte_order, data_type, wavelength, wavelength_unit] = extract_parameters(PathName,Filename);
    
    Irow = 1:Nlines; % Indexes of rows
    Icol = 1:Nsamples; % Indexes of columns
    Iband = 1:Nbands; % Indexes of bands
    
    data_type = strcat(data_type,'=>','double'); %concaténation des 2 strings
    data = multibandread(fullfile(PathName,FileName),[Nlines,Nsamples,Nbands],data_type,offset,interleave,byte_order,{'Column',Icol},{'Row',Irow},{'Band',Iband});
    data = double(data)/100000; % scaling to obtain reflectance values (0<...<1)
    
    z = data(:,:,RGB); %ajout des "vraies" couleurs, ou de la couleur en niveau de gris.
    if (length(RGB)>1)
        %Affichage dans la figure courante
        imagesc(z/max(z(:))) %affichage avec le gamme de couleurs choisie
    else
        colormap(gray);
        imagesc(squeeze(z/max(z(:))));
    end
    set(handles(48),'visible','off');
    set(handles(19),'string', [FileName ' loaded.']);
end
end

