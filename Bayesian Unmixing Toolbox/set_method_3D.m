function set_method_3D(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the type of method chosen for the analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global geo_method handles RGB data  Nsamples Nbands Nlines wavelength_unit wavelength sources R M_est current_plot handles_subplot x_pixel y_pixel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Conserver les handles des subplot dans ma fenêtre principale, puis les
% supprimer... Seule façon de pouvoir retracer correctement les images.
% (prendre une variable handles_subplot...)
% handles_subplot(k) = subplot(2,7,2:3); en variable globale, ou à placer
% en paramètre de la fonction sur laquelle interviennent les modifs..., ou
% alors question de visibilité...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Valeur de geo_method
geo_method=get(handles(33),'value');
current_plot = 0;

switch geo_method
    case 1
        geo_method='nfindr';
        set(handles(49),'visible','off'); %affichage bouton "unmix"
        set(handles(21),'visible','on'); %suppression bouton "estimate"
    case 2
        geo_method='vca';
        set(handles(49),'visible','off'); %affichage bouton "unmix"
        set(handles(21),'visible','on'); %suppression bouton "estimate"
    case 3
        geo_method='Sources selection';
        
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
        
        if isempty(data)
            disp('Error : no image loaded.');
            return;
        else
            t = size(sources);
            if (t(2)<R)
            z=data(:,:,RGB); %ajout des "vraies" couleurs
            
                if (length(RGB)>1)

                    %Affichage dans la figure courante
                    imagesc(z/max(z(:))) %affichage avec le gamme de couleurs choisie
                    axis image;
                    plot_points;
                else
                    colormap(gray);
                    imagesc(squeeze(z/max(z(:))));
                    axis image;
                    plot_points;
                end
                
                [x y b] = ginput(1); %instruction à relancer dans confirm !
                if b==1
                    %tracé du contenu spectral d'un seul pixel
                    x = round(x); %prise des coordonnées du point : on prend la partie entière !
                    y = round(y);
                    if (x<=Nsamples) && (y<=Nlines) &&(x>0) && (y>0)
                        pixel = data(y,x,:); %pixel sélectionné dans l'image
                        pixel = reshape(pixel,Nbands,1);
                        x_pixel = [x_pixel; x];
                        y_pixel = [y_pixel; y];
                        plot_points;
                           
                        
                        %Affichage de la position du pixel sélectionné sur la
                        %figure et du numéro de la source sélectionnée
                        t = size(sources);
                        pos = strcat('Source n° ', num2str(t(2)+1),' : spectrum of the pixel',' [',num2str(x),',', num2str(y),']');

                        fig2 = figure;

                        % Création de l'objet Uicontrol text file
                        handles_local(1) = uicontrol('style','text',...
                        'units','normalized',...
                        'position',[0.25 0.95 0.5 0.035],...
                        'tag','file',...
                        'string',pos,...
                        'foregroundcolor',[0 0 0]);
                        unit = strcat('Unit : ', wavelength_unit);

                        % Création de l'objet Uicontrol text file
                        handles_local(2) = uicontrol('style','text',...
                        'units','normalized',...
                        'position',[0.0 0.0 0.2 0.035],...
                        'tag','file',...
                        'string',unit,...
                        'foregroundcolor',[0 0 0]);

                        % Bouton "confirm"    
                        handles_local(3) = uicontrol('style','push',...
                        'units','normalized',...
                        'position',[0.3 0 0.1 0.05],...
                        'callback',@(obj,event)confirm(obj,event,fig2,pixel),...
                        'tag','confirm',...
                        'string','Confirm');

                        % Bouton "cancel"
                        handles_local(4) = uicontrol('style','push',...
                        'units','normalized',...
                        'position',[0.65 0 0.1 0.05],...
                        'callback',@(obj,event)cancel(obj,event,fig2),... %relancer en plus le curseur...
                        'tag','cancel',...
                        'string','Cancel');

                        plot(wavelength,pixel); %tracé du contenu spectral du pixel considéré
                        xlabel('Wavelength')
                        ylabel('Amplitude')
                    else
                        disp('Error, select a pixel on the image'); %à afficher ailleurs
                    end
                end
            else
                disp('Delete previous sources before any other acquisition.');
                estimate_3D;
                return;
               
            end
        end

    case 4
            geo_method='from file';
           
end
       
end
