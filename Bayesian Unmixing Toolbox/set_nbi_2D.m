
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEBUT DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_nbi_2D(obj,event)

% Définition de Nbi et handles comme variables globales dans chaque fonction et sous-fonction
% handles : identifiants des objets graphiques (vecteur)
global handles Nbi

% valeur de Nmc
Nbi=get(handles(12),'string');
Nbi=str2num(Nbi);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIN DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%