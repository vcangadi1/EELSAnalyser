function plot_spectra(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function associated to the menu "plot spectra". 
% Plots the spectrum of a pixel selected on the converted *.envi
% true color image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Nlines Nsamples Nbands data wavelength_unit RGB wavelength handles_subplot handles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

%Plot true color image
if isempty(data)
    disp('Error : no imge loaded.');
    return;
else
    z = data(:,:,RGB); %ajout des "vraies" couleurs
    if (length(RGB)>1)
        
        %Affichage "true color"
        imagesc(z/max(z(:)));
        axis image;
    else
        %Affichage "gray scale"
        colormap(gray);
        imagesc(squeeze(z/max(z(:))));
        axis image;
    end
    b = 1;
    fig1 = figure(1);
    while b==1
        
        [x y b] = ginput(1);
        if b==1
            %tracé du contenu spectral d'un seul pixel
            x = round(x); %prise des coordonnées du point : on prend la partie entière !
            y = round(y);
            if (x<=Nsamples) && (y<=Nlines) &&(x>0) && (y>0) 
                pixel = data(y,x,:); %pixel sélectionné dans l'image
                pixel = reshape(pixel,Nbands,1);
                %Affichage de la position du pixel sélectionné sur la figure
                pos = strcat('Spectrum of the pixel',' [',num2str(x),',', num2str(y),']');

                fig2 = figure(2);

                %Tracé de l'image de base
                subplot(2,1,1);   
                if (length(RGB)>2)
                    imagesc(data(:,:,RGB)/max(z(:))) %affichage avec le gamme de couleurs choisie
                    axis image;
                else
                    colormap(gray);
                    imagesc(squeeze(z/max(z(:))));
                    axis image;
                end
                
                rect = rectangle('Position',[x-0.5,y-0.5,1,1], 'EdgeColor', [1, 0, 0]); %affichage d'un rectangle à l'endroit du pixel sélectionné
                
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
                
                subplot(2,1,2);
                plot(wavelength,pixel); %tracé du contenu spectral du pixel considéré
                title('Pixel spectrum');
                xlabel('Wavelength');
                ylabel('Amplitude');

            else
                disp('Error, select a pixel on the image'); %à afficher ailleurs
            end
        end
    end
end
end

