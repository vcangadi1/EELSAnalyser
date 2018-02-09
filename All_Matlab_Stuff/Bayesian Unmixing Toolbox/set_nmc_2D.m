
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEBUT DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_nmc_2D(obj,event)

% Définition de Nmc et handles comme variables globales dans chaque fonction et sous-fonction
% handles : identifiants des objets graphiques (vecteur)
global handles Nmc

% valeur de Nmc
Nmc=get(handles(10),'string');
Nmc=str2num(Nmc);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIN DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%