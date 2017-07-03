function load_envi(object,event) 
%Callback function associated to the menu "load envi".
%Loads an ENVI image, plots a true color image. 

%Remarques : (éléments à faire)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ajuster la taille de l'image dans la fenêtre de l'interface

%laisser la possibilité à l'utilisateur de choisir RGB, mettre une valeur
%par défaut

%adapter la fonction au choix d'un affichage en niveau de gris

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global data Nlines Nsamples Nbands wavelength_unit interleave offset byte_order data_type wavelength handles FileName PathName RGB R
%% Error test

            

        subplot(1,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])
%         subplot(2,7,9:14)
%         set(gca,'color',[0.75 0.75 0.75])
%         set(gca,'Xcolor',[0.75 0.75 0.75])
%         set(gca,'Ycolor',[0.75 0.75 0.75])


test=get(handles(997),'visible');
[i j]=size(test);
if j==2
    set(handles(996),'visible','off')
    set(handles(997),'visible','off')
    set(handles(998),'visible','off')
end

test=get(handles(996),'visible');
[i j]=size(test);
if j==2
    set(handles(996),'visible','off')
end

clear i j

%[FileName,PathName] = uigetfile({'*.hdr'},'Select the header file'); % Choisir un fichier, format filtré par la commande
[FileName,PathName] = uigetfile({'*'},'Select the envi image'); % Choisir un fichier, format filtré par la commande : '*' signifie que la recherche s'effectue sur tous les types de fichiers

if (FileName == 0) %dans le cas où l'on décide d'annuler la sélection
    
    return;

else
    Filename = strcat(FileName, '.hdr'); %nom du fichier header dont les paramètres utiles sont extraits
    [Nsamples, Nlines, Nbands, interleave, offset, byte_order, data_type, wavelength, wavelength_unit] = extract_parameters(PathName,Filename);

    Irow = 1:Nlines; % Indexes of rows
    Icol = 1:Nsamples; % Indexes of columns
    Iband = 1:Nbands; % Indexes of bands

    %FileName = strtok(FileName, '.'); %on enlève le .hdr de la chaîne de caractères initiale
    data_type = strcat(data_type,'=>','double'); %concaténation des 2 strings

    data = multibandread(fullfile(PathName,FileName),[Nlines,Nsamples,Nbands],data_type,offset,interleave,byte_order,{'Column',Icol},{'Row',Irow},{'Band',Iband});

    data = double(data)/100000; % scaling to obtain reflectance values (0<...<1)

    %Plot true color image
    z = data(:,:,RGB); %ajout des "vraies" couleurs, ou de la couleur en niveau de gris.

    if (length(RGB)>1)
        
        %Affichage dans la figure courante
        imagesc(z/max(z(:))) %affichage avec le gamme de couleurs choisie
        axis image;
    else
        colormap(gray);
        imagesc(squeeze(z/max(z(:))));
        axis image;
    end
    
    %Save extracted data in a '*.mat' file.
    save(strcat(FileName,'.mat'), 'Nlines', 'Nsamples', 'Nbands', 'data', 'interleave', 'offset', 'byte_order', 'data_type', 'wavelength') %on indique ce que l'on enregistre dans FileName.mat
    
    disp([FileName ' loaded']) %affichage à faire dans la fenêtre de l'interface !!
    set(handles(19),'string',[FileName ' loaded.'])
end
end