function select_area(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select a sub-area of the original image on which the separation algorithm
% is applied.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global data  Nsamples Nlines Nbands offset interleave byte_order data_type wavelength RGB  FileName handles handles_subplot
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

if isempty(data)
    disp('Error : no image loaded.');
    return;
else
    b = [1 1];
    z=data(:,:,RGB); %ajout des "vraies" couleurs
    imagesc(z/max(z(:)));
    axis image;
    
    if (b(1) == 1) && (b(2) == 1)
        
        [x y b] = ginput(2);
        x = round(x); %prise des coordonnées du point : on prend la partie entière !        
        y = round(y); %y correspond à la ligne de la matrice, x à a colonne
        
        if (x(1)<=Nsamples) && (x(2)<=Nsamples) && (y(1)<=Nlines) && (y(2)<=Nlines) && (x(1)>0) && (x(2)>0) && (y(1)>0) && (y(2)>0) 
            
            if (x(1)>=x(2)) || (y(1)>=y(2))
                disp('Error : first select the top left-hand corner of the area, then the bottom right-hand corner.')
                return;
            else
                
                z=data((y(1):y(2))',(x(1):x(2))',RGB); % à spécifier dans l'aide, faire message d'ereur si le schéma n'est pas vérifié
                imagesc((x(1):x(2))',(y(1):y(2))',data((y(1):y(2))',(x(1):x(2))',RGB)/max(z(:))); %spécification du coin inférieur gauche, puis du point supérieur droit.
                axis image;
                %Actualisation des données
                data = data((y(1):y(2))',(x(1):x(2))',:); %on ne garde que la portion "utile" de l'image.
                Nsamples = x(2)-x(1)+1;
                Nlines = y(2)-y(1)+1;

                selected_area = strcat( 'x in [',num2str(x(1)),',',num2str(x(2)),'], y in [',num2str(y(1)),',',num2str(y(2)),']');

                %save(strcat(FileName, '_selected_area','.mat'), 'selected_area','Nlines', 'Nsamples', 'Nbands', 'data', 'interleave', 'offset', 'byte_order', 'data_type', 'wavelength')
                set(handles(19),'string',['Area loaded.'])
            end
        else
            disp('Error, select pixels on the image');
        end
    else
        return;
    end
    set(handles(48),'visible','on'); %displays "cancel sub-analysis" menu.
end

end

