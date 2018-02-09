function delete_sources(obj,event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete the selected or loaded sources (pre-estimation).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sources handles current_plot handles_subplot RGB data bool_plot x_pixel y_pixel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
current_plot = 0;
sources = [];
x_pixel = [];
y_pixel = [];
set(handles(24),'visible','off');

disp('Sources deleted.');

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


%Réaffichage de l'image de base :
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

set(handles(49),'visible','off'); %suppression du bouton Launch Bayesian unmixing
set(handles(21),'visible','on'); %seule l'estimation de base est accessible
end

