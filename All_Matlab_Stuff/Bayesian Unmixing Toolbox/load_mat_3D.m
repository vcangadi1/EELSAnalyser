function load_mat_3D(object,event) 
%Callback function associated to a menu
%Loads a .mat file in the workspace

%le fichier doit contenir des variables nommées wavelength, data, ...., puis
%afficher l'image en utilisant la bonne matrice (format 3D ou  autre -> reshape éventuel ??)

global data Nlines Nsamples Nbands R wavelength handles FileName PathName RGB wavelength_unit

%% Error test

        subplot(1,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])

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

[FileName,PathName] = uigetfile({'*.mat'},'Select a file'); % Choisir un fichier, format filtré par la commande
if (FileName == 0) %annulation de la commande
    
    return;
    
else
    
    %data=load([PathName FileName]);
    disp([FileName ' loaded'])
    set(handles(19),'string',[FileName ' loaded'])
    
    structfile = load([PathName FileName]);
    structfield = fieldnames(structfile);
    data = structfile.(structfield{1});
%     data = Y; %Nom Y nécessaire
    [Nlines Nsamples Nbands] = size(data);
    wavelength = 1:Nbands;
    wavelength_unit=' N A';
    
    
    %Irow = 1:Nlines; % Indexes of rows
    %Icol = 1:Nsamples; % Indexes of columns
    %Iband = 1:Nbands; % Indexes of bands

    %FileName = strtok(FileName, '.'); %on enlève le .hdr de la chaîne de caractères initiale
    %data_type = strcat(data_type,'=>','double'); %concaténation des 2 strings

    %data = multibandread(fullfile(PathName,FileName),[Nlines,Nsamples,Nbands],data_type,offset,interleave,byte_order,{'Column',Icol},{'Row',Irow},{'Band',Iband});

   % data = double(data)/100000; % scaling to obtain reflectance values (0<...<1)

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
    %save(strcat(FileName,'.mat'), 'Nlines', 'Nsamples', 'Nbands', 'data', 'interleave', 'offset', 'byte_order', 'data_type', 'wavelength') %on indique ce que l'on enregistre dans FileName.mat
    
    disp([FileName ' loaded']) %affichage à faire dans la fenêtre de l'interface !!
    set(handles(19),'string',[FileName ' loaded.'])
end


end

