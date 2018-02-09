function confirm(obj,event,fig2,pixel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Confirm the selection of a pixel as a source.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sources handles R  %R : nombre de sources entré par l'utilisateur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(sources,pixel)
    close(fig2);
    disp('Error : pixel previously selected');
    set_method_3D(obj,event);
else
    sources = [sources, pixel];
    close(fig2);
    set(handles(24),'visible','on'); %affiche le bouton delete en cas de confirmation de la sélection d'une source
    set_method_3D(obj,event);
end


end

