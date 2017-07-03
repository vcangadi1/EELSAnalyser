function display_image(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Displays the .envi image loaded on the interface.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global handles data RGB R
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Error test




        [i j]=size(data);

        if i==0
            if j==0
            disp('Error : No file to analyze')
            return
            end
        end

            if R<=2
            disp('Error : Number of sources must be greater than 3')
            return
            end
            

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

%% Tracé
if isempty(data)
    disp('Error : no image loaded.');
    return;
else
    z = data(:,:,RGB);
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
end

end

